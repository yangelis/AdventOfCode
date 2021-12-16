module aoc
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  implicit none

  type, public :: Pair
     integer :: first
     integer :: second
  end type Pair

  type, public :: String
     integer :: str_size
     character(len=:), allocatable :: data
   contains
     final :: str_dealloc
  end type String

  type, public :: StringView
     character(len=:), pointer :: data
     integer(i32) :: endp
  end type StringView

  type, public :: Veci32
     integer(i32) :: n, fixed_size
     integer(i32), allocatable :: data(:)
   contains
     final :: vec_dealloc
  end type Veci32

  type, public :: VecSV
     integer(i32) :: n
     type(StringView), allocatable :: data(:)
  end type VecSV

contains
  type(String) function new_str(s)
    character(len=:), allocatable :: s

    new_str%data = s
    new_str%str_size = len(s)
  end function new_str


  ! NOTE: gfortran has issues with final functions
  ! that's why we have strfree
  subroutine str_dealloc(this)
    type(String), intent(inout) :: this

    if (allocated(this%data)) deallocate (this%data)
    this%str_size = 0
  end subroutine str_dealloc

  subroutine strfree(str)
    type(String), intent(inout) :: str

    deallocate(str%data)
    str%str_size = 0
  end subroutine strfree

  function countlines(filename) result(n)

    character (len=10), intent(in) :: filename
    integer :: stat
    integer, parameter :: read_unit = 9
    integer :: n

    n = 0

    ! opening the file for reading
    open(read_unit, file = filename)

    do
       read(read_unit,'(A)', iostat=stat)
       if (stat > 0)  then
          exit
       else if (stat < 0) then
          exit
       else
          n = n + 1
       end if
    end do

    close(read_unit)

    return
  end function countlines

  subroutine readfile(filename, buffer)
    integer :: rc, fd, file_size
    character (len=30), intent(in) :: filename
    type(String), intent(out) :: buffer
    logical :: file_exists

    open (access='stream', action='read', file=filename, &
         form='unformatted', iostat=rc, newunit=fd)

    if (rc /= 0) stop 'Error: opening file failed'

    inquire (exist=file_exists, file=filename, size=file_size)

    allocate(character(len=file_size) :: buffer%data)
    buffer%str_size = file_size

    if (rc /= 0) stop 'Error: open failed'
    read (fd, iostat=rc) buffer%data
    close (fd)
  end subroutine readfile

  function readlines(filename) result(lines)
    integer :: i, nlines
    integer :: start, endp
    character (len=1) :: nl
    character (len=30), intent(in) :: filename
    type(String) :: file_content
    type(String), allocatable :: lines(:)

    nl = new_line("")

    call readfile(filename, file_content)

    nlines = countlines(filename)
    allocate(lines(nlines))

    start = 1
    endp = scan(file_content%data, nl) - 1
    do i = 1, nlines
       lines(i)%data = file_content%data(start:endp)
       lines(i)%str_size = endp - start + 1
       start = endp + 2
       endp = scan(file_content%data(start:), nl)  + start - 2
    end do

  end function readlines

  integer function str2int(str) result(r)
    type(String), intent(in) :: str
    integer :: stat
    read(str%data, *, iostat=stat) r
  end function str2int

  ! splits each line into two strings
  function splitlinesby(str, nlines, ch) result(content)
    type(String), intent(in) :: str
    integer, intent(in) :: nlines
    character (len=1), intent(in) :: ch
    type(String), allocatable :: content(:)
    integer :: i, start, anchor, ipos
    integer :: temp1, temp2
    character (len=1) :: nl

    nl = new_line("")

    allocate(content(2*nlines))

    start = 1
    anchor = scan(str%data, nl)

    do i = 1, nlines
       ipos = scan(str%data(start:anchor), ch) + start

       temp1 = ipos - 2
       content(2*i - 1)%data = str%data(start:temp1)
       content(2*i - 1)%str_size = len(str%data(start:temp1))

       temp2 = anchor - 1
       content(2*i)%data = str%data(ipos:temp2)
       content(2*i)%str_size = len(str%data(ipos:temp2))
       start = anchor + 1
       anchor = start + scan(str%data(start:), nl) - 1
    end do

    return
  end function splitlinesby

  function sv_from_characters(n, s) result(sv)
    integer(i32), intent(in) :: n
    character(len=n), target, intent(in) :: s
    type(StringView) :: sv
    integer(i32) :: i, m, nn

    nn = n

    do i = n,1,-1
       if (s(i:i) /= ' ') exit
       nn = nn -1
    end do

    m = 0
    do i = 1, nn
       m = m + 1
       if (s(i:i) .eq. '\0') exit
    end do

    sv%data => s(1:m)
    sv%endp = m
  end function sv_from_characters

  function split(str, delim, limit) result(strs)
    type(String), intent(in) :: str
    character(len=1), intent(in) :: delim
    integer(i32), intent(in) :: limit
    integer(i32) :: i, j, k, n, r, count
    type(VecSV) :: strs

    allocate(strs%data(limit))
    count = 0

    i = 1 ! first index
    n = str%str_size

    r = scan(str%data(i:), delim)
    if (r > 0) then
       j = r
       k = r + 1
       do while (0 < j .and. j <= n .and. count /= limit-1)
          if (i < k ) then
             if (i < j) then
                count = count + 1
                strs%data(count) = sv_from_characters(len(str%data(i:j-1)), str%data(i:j-1))
             end if
             i = k
          end if
          if ( k <= j ) k = j + 1
          r = scan(str%data(k:) , delim)
          if ( r == 0 ) exit
          if (r > 0) r = r + k - 1
          j = r
          k = r + 1
       end do
    end if

    if ( i <= n ) then
       count = count + 1
       strs%data(count) = sv_from_characters(len(str%data(i:)), str%data(i:))
    end if
    strs%n = count
  end function split

  type(Veci32) function new_veci32(n)
    integer(i32), intent(in) :: n
    if ( n < 100 ) then
       new_veci32%fixed_size = 100
    else
       new_veci32%fixed_size = n
    end if
    new_veci32%n = n
    allocate(new_veci32%data(new_veci32%fixed_size))
    new_veci32%data = 0
  end function new_veci32

  subroutine vec_dealloc(this)
    type(Veci32), intent(inout) :: this

    if (allocated(this%data)) deallocate (this%data)
    this%n = 0
    this%fixed_size = 0
  end subroutine vec_dealloc

  function findall1d(v1, n, m2) result(indices)
    integer(i32), intent(in) :: v1
    integer(i32), intent(in) :: n
    integer(i32), intent(in) :: m2(n)
    integer(i32), allocatable :: indices(:)
    integer(i32) :: i

    allocate(indices(n))
    indices = -1

    do i = 1, n
       if (v1 == m2(i)) then
          indices(i) = 1
       end if
    end do
  end function findall1d

  function findall2d(v1, n, m, m2) result(indices)
    integer(i32), intent(in) :: v1
    integer(i32), intent(in) :: n, m
    integer(i32), intent(in) :: m2(n, m)
    integer(i32), allocatable :: indices(:, :)
    integer(i32) :: i, j

    allocate(indices(n, m))
    indices = -1

    do j = 1, m
       do i = 1, n
          if (v1 == m2(i, j)) then
             indices(i, j) = 1
          end if
       end do
    end do
  end function findall2d

  function findall3d(v1, n, m, q, m2) result(indices)
    integer(i32), intent(in) :: v1
    integer(i32), intent(in) :: n, m, q
    integer(i32), intent(in) :: m2(n, m, q)
    integer(i32), allocatable :: indices(:, :, :)
    integer(i32) :: i, j, k

    allocate(indices(n, m, q))
    indices = -1

    do k = 1, q
       do j = 1, m
          do i = 1, n
             if (v1 == m2(i, j, k)) then
                indices(i, j, k) = 1
             end if
          end do
       end do
    end do
  end function findall3d
end module aoc
