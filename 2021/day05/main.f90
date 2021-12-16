module day05
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  use aoc, only: String, readlines, new_str
  implicit none

  type, public :: Pos
     integer(i32) :: x, y
  end type Pos

  type, public :: Line
     type(Pos) :: start_p, stop_p
  end type Line

contains
  function findall1d_str(v, s) result(indices)
    type(String), intent(in) :: v, s
    integer(i32) :: indices(2)
    integer(i32) :: i, j

    indices(1) = -1
    indices(2) = -1

    j = 1
    do i = 1, (s%str_size-v%str_size)
       if (v%data(1:v%str_size) == s%data(i:i+v%str_size-1)) then
          indices(j) = i
          j = j + 1
       end if
    end do
  end function findall1d_str

  function parseposition(nlines, lines) result(segments)
    integer(i32), intent(in) :: nlines
    type(String), intent(in) :: lines(nlines)
    integer(i32) :: i
    type(Line), allocatable :: segments(:)
    type(Line) :: temp
    type(Pos) :: ps(2)
    type(String) :: ch1, ch2
    integer(i32) :: spaces(2), commas(2)

    ch1%data = " "
    ch1%str_size = 1
    ch2%data = ","
    ch2%str_size = 1

    allocate(segments(nlines))

    do i = 1, nlines
       spaces = findall1d_str(ch1, lines(i))
       commas = findall1d_str(ch2, lines(i))
       read(lines(i)%data(1:commas(1)-1), *) ps(1)%x
       read(lines(i)%data(commas(1)+1:spaces(1)-1), *) ps(1)%y

       read(lines(i)%data(spaces(2)+1:commas(2)-1), *) ps(2)%x
       read(lines(i)%data(commas(2)+1:), *) ps(2)%y

       temp%start_p = ps(1)
       temp%stop_p = ps(2)
       segments(i) = temp
    end do
  end function parseposition

  function find_grid_size(n, segments) result(gsize)
    integer(i32), intent(in) :: n
    type(Line), intent(in) :: segments(n)
    integer(i32) :: gsize(2), max_x, max_y, i

    max_x = 0
    max_y = 0

    do i = 1, n
       if (segments(i)%start_p%x > max_x) max_x = segments(i)%start_p%x
       if (segments(i)%start_p%y > max_y) max_y = segments(i)%start_p%y
       if (segments(i)%stop_p%x > max_x) max_x = segments(i)%stop_p%x
       if (segments(i)%stop_p%y > max_y) max_y = segments(i)%stop_p%y
    end do

    gsize(1) = max_x + 1
    gsize(2) = max_y + 1
  end function find_grid_size

  function part1(grid_size, n, segments) result(c)
    integer(i32), intent(in) :: grid_size(2)
    integer(i32), intent(in) :: n
    type(Line), intent(in) :: segments(n)
    integer(i32), allocatable :: grid(:, :)
    integer(i32) :: i, j, c, x1, y1, x2, y2

    allocate(grid(grid_size(1), grid_size(2)))
    do j = 1, grid_size(2)
       do i = 1, grid_size(1)
          grid(i, j) = 0
       end do
    end do

    do i = 1, n
       if (segments(i)%start_p%x == segments(i)%stop_p%x) then
          y1 = min(segments(i)%start_p%y, segments(i)%stop_p%y) + 1
          y2 = max(segments(i)%start_p%y, segments(i)%stop_p%y) + 1
          grid(y1:y2, segments(i)%start_p%x + 1) = grid(y1:y2, segments(i)%start_p%x + 1) + 1
       else if (segments(i)%start_p%y == segments(i)%stop_p%y) then
          x1 = min(segments(i)%start_p%x, segments(i)%stop_p%x) + 1
          x2 = max(segments(i)%start_p%x, segments(i)%stop_p%x) + 1
          grid(segments(i)%start_p%y + 1, x1:x2) = grid(segments(i)%start_p%y + 1, x1:x2) + 1
       end if
    end do


    c = 0
    do j = 1, grid_size(2)
       do i = 1, grid_size(1)
          if (grid(i, j) > 1 ) c = c + 1
       end do
    end do
  end function part1

  function part2(grid_size, n, segments) result(c)
    integer(i32), intent(in) :: grid_size(2)
    integer(i32), intent(in) :: n
    type(Line), intent(in) :: segments(n)
    integer(i32), allocatable :: grid(:, :)
    integer(i32) :: i, j, c, x1, y1, x2, y2
    integer(i32) :: diff, stepx, stepy
    type(Pos) :: p1

    allocate(grid(grid_size(1), grid_size(2)))
    do j = 1, grid_size(2)
       do i = 1, grid_size(1)
          grid(i, j) = 0
       end do
    end do

    do i = 1, n
       if (segments(i)%start_p%x == segments(i)%stop_p%x) then
          y1 = min(segments(i)%start_p%y, segments(i)%stop_p%y) + 1
          y2 = max(segments(i)%start_p%y, segments(i)%stop_p%y) + 1
          grid(y1:y2, segments(i)%start_p%x + 1) = grid(y1:y2, segments(i)%start_p%x + 1) + 1
       else if (segments(i)%start_p%y == segments(i)%stop_p%y) then
          x1 = min(segments(i)%start_p%x, segments(i)%stop_p%x) + 1
          x2 = max(segments(i)%start_p%x, segments(i)%stop_p%x) + 1
          grid(segments(i)%start_p%y + 1, x1:x2) = grid(segments(i)%start_p%y + 1, x1:x2) + 1
       else if (abs(segments(i)%stop_p%y - segments(i)%start_p%y) == abs(segments(i)%stop_p%x - segments(i)%start_p%x)) then
          diff = max(abs(segments(i)%stop_p%y - segments(i)%start_p%y), abs(segments(i)%stop_p%x - segments(i)%start_p%x))
          stepx = 1
          stepy = 1
          if (segments(i)%start_p%y > segments(i)%stop_p%y ) stepy = - 1
          if (segments(i)%start_p%x > segments(i)%stop_p%x ) stepx = - 1

          p1 = segments(i)%start_p

          do j = 0, diff
             grid(p1%y+1, p1%x+1) =  grid(p1%y+1, p1%x+1) + 1
             p1%x = p1%x + stepx
             p1%y = p1%y + stepy
          end do
       end if
    end do

    c = 0
    do j = 1, grid_size(2)
       do i = 1, grid_size(1)
          if (grid(i, j) >= 2 ) c = c + 1
       end do
    end do
  end function part2

end module day05

program main
  use day05
  implicit none
  BLOCK
    integer(i32) :: nlines, p1, p2
    type(String), allocatable :: lines(:)
    character (len=30) :: filename
    type(Line), allocatable :: segments(:)
    integer(i32) :: grid_size(2)

    ! filename = 'test.txt'
    filename = 'input.txt'
    write(*, *) "Reading file: ", filename

    lines = readlines(filename)
    nlines = size(lines)
    segments = parseposition(nlines, lines)
    grid_size = find_grid_size(nlines, segments)

    p1 = part1(grid_size, nlines, segments)
    write(*, *) "Part1: ", p1

    p2 = part2(grid_size, nlines, segments)
    write(*, *) "Part2: ", p2
  end BLOCK
end program main
