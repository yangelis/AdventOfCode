module aoc
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  implicit none

  private
  public String, new_str, strfree, readfile, countlines, str2int, splitlinesby, readlines



  type, public :: String
     integer :: str_size
     character(len=:), allocatable :: data
   contains
     final :: str_dealloc
  end type String

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

end module aoc
