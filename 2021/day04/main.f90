module day04
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  use aoc, only: String, str2int, readlines, countlines, new_str
  implicit none

  type, public :: Pair
     integer :: first
     integer :: second
  end type Pair

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

  function string_from_characters(n, s) result(str)
    integer(i32), intent(in) :: n
    character(len=n), intent(in) :: s
    type(String) :: str
    integer(i32) :: i, m

    m = 0
    do i = n, 1, -1
       if (s(i:i) .eq. ' ') then
          m = m + 1
       else
          exit
       end if
    end do

    m = n - m
    str%data = s(1:m)
    str%str_size = m
  end function string_from_characters

  function chop_by_delim(sv, delim) result(s)
    type(StringView), intent(inout) :: sv
    character(len=1), intent(in) :: delim
    integer(i32) :: i
    type(StringView) :: s

    i = 1
    do while (i < sv%endp .and. sv%data(i:i) .ne. delim)
       i = i + 1
    end do

    if ( i == 1 ) i = i + 1
    s%data => sv%data(1:i-1)
    s%endp = i - 1

    if ( i < sv%endp ) then
       sv%endp = sv%endp - i
       sv%data => sv%data(i+1:)
    else
       sv%endp = sv%endp - i - 1
       sv%data => sv%data(i:)
    end if
  end function chop_by_delim

  function parsedrawer(nlines, lines) result(drawer)
    integer(i32), intent(in) :: nlines
    type(String), intent(in) :: lines(nlines)
    type(VecSV) :: s
    integer(i32) :: i, n
    type(Veci32) :: drawer

    s = split(lines(1), ',', 30)

    n = s%n
    drawer = new_veci32(n)
    drawer%data = 0
    do i = 1, n
       read(s%data(i)%data(1:s%data(i)%endp), *) drawer%data(i)
    end do

  end function parsedrawer

  function parseboards(nlines, lines) result(boards)
    integer(i32), intent(in) :: nlines
    type(String), intent(in) :: lines(nlines)
    integer(i32), allocatable :: boards(:, :, :)
    integer(i32) :: i, j, k, n, m, a
    type(VecSV) :: s

    n = (nlines - 1)/5
    allocate(boards(n, 5, 5))
    boards = 0
    i = 1
    BLOCKS:do m = 3, nlines, 6
       ROWS:do j = 0, 4
          s = split(lines(m + j), ' ', 6)
          a = s%n
          COLS:do k = 1, a
             if (s%data(k)%endp <= 0) cycle COLS
             read(s%data(k)%data, *) boards(i, j + 1, k)
          end do COLS
       end do ROWS
       i = i + 1
    end do BLOCKS
  end function parseboards

  function split_by(str, ch) result(parts)
    type(String), intent(in) :: str
    character(len=1), intent(in) :: ch
    integer(i32) :: i, start, endp, nparts
    type(StringView), allocatable :: parts(:)
    type(StringView) :: s, sv

    start = 1
    endp = scan(str%data, ch)
    nparts = 0
    do while (endp - start .gt. 0)
       nparts = nparts + 1
       start = endp
       endp = scan(str%data(start:), ch) + start
       if ( start <= str%str_size) then
          if(str%data(start:start) == ch) then
             start = start + 1
             endp = endp + 1
          end if
       end if
    end do

    allocate(parts(nparts))


    i = 1
    sv = sv_from_characters(str%str_size, str%data)
    do while( sv%endp > 0 )
       s = chop_by_delim(sv, ch)
       parts(i) = s
       i = i + 1
    end do
  end function split_by

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

  function findall(v1, m2) result(indices)
    integer(i32), intent(in) :: v1
    integer(i32), intent(in) :: m2(:, :)
    type(Pair), allocatable :: indices(:)
    integer(i32) :: sh(2)
    integer(i32) :: i, j, n, m
    n = size(m2)
    allocate(indices(n))
    indices(:)%first = -1
    indices(:)%second = -1
    sh = shape(m2)
    n = sh(1)
    m = sh(2)

    do j = 1, n
       do i = 1, m
          if (v1 == m2(i, j)) then
             indices(i + (j-1)*n)%first = 1
             indices(i + (j-1)*n)%second = 1
          end if
       end do
    end do
  end function findall

  function part1(drawer, boards) result(p)
    type(Veci32), intent(in) :: drawer
    integer(i32), intent(in) :: boards(:, :, :)
    integer(i32) :: board_shape(3)
    integer(i32) :: bn, bm, bk, p, s
    integer(i32) :: i, j, jj, ii, ij2(1)
    integer(i32), allocatable :: selected(:, :, :)
    integer(i32) :: ij(2)
    type(Pair), allocatable :: indices(:)

    board_shape = shape(boards)
    bn = board_shape(1)
    bm = board_shape(2)
    bk = board_shape(3)

    allocate(selected(bn, bm, bk))
    selected = 0

    ij = 0

    DRAWER_LOOP: do i = 1, drawer%n
       BOARD_LOOP: do j = 1, bn
          ij = findloc(boards(j, :, :), drawer%data(i))
          if (ij(1) > 0 .and. ij(2) > 0) then
             selected(j, ij(1), ij(2)) = 1
             if (sum(selected(j, ij(1), :)) == 5 .or. sum(selected(j, :, ij(2))) == 5) then
                s = 0
                do jj = 1, bk
                   do ii = 1, bm
                      if ( selected(j, ii, jj) == 0 ) s = s + boards(j, ii, jj)
                   end do
                end do
                p = s * drawer%data(i)
                exit DRAWER_LOOP
             end if
          end if
       end do BOARD_LOOP
    end do DRAWER_LOOP

  end function part1

end module day04

program main
  use day04
  implicit none

  BLOCK
    integer(i32) :: nlines, p1, p2, i
    type(String), allocatable :: lines(:)
    character (len=30) :: filename
    type(Veci32) :: drawer
    integer(i32), allocatable :: boards(:, :, :)

    ! filename = 'test.txt'
    filename = 'input.txt'
    write(*, *) "Reading file: ", filename

    lines = readlines(filename)
    nlines = size(lines)

    drawer = parsedrawer(nlines, lines)
    boards = parseboards(nlines, lines)

    p1 = part1(drawer, boards)
    write(*, *) "Part1: ", p1



    ! deallocate(lines)
    ! deallocate(drawer)
  end BLOCK
end program main
