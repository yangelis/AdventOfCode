module day02
  use aoc, only: String, str2int
  implicit none

  type, public :: Direction
     type(String) :: s
     integer :: step
  end type Direction

  type, public :: Pos
     integer :: x, y
  end type Pos

  type, public :: NewPos
     integer :: x, y, aim
  end type NewPos

contains

  function part1(ctx, n) result(r)
    integer, intent(in) :: n
    type(String), intent(in) :: ctx(n)
    type(Pos) :: start_pos
    integer :: i
    integer :: r

    r = 0

    start_pos%x = 0
    start_pos%y = 0

    do i=1, n
       if ( ctx(2*i - 1)%data(1:1) .eq. 'f' ) then
          start_pos%x = start_pos%x + str2int(ctx(2*i))
       elseif ( ctx(2*i - 1)%data(1:1) .eq. 'u' ) then
          start_pos%y = start_pos%y - str2int(ctx(2*i))
       elseif ( ctx(2*i - 1)%data(1:1) .eq. 'd' ) then
          start_pos%y = start_pos%y + str2int(ctx(2*i))
       end if
    end do

    r = start_pos%x * start_pos%y
    return
  end function part1

  function part2(ctx, n) result(r)
    integer, intent(in) :: n
    type(String), intent(in) :: ctx(n)
    type(NewPos) :: start_pos
    integer :: i
    integer :: r

    r = 0

    start_pos%x = 0
    start_pos%y = 0
    start_pos%aim = 0

    do i=1, n
       if ( ctx(2*i - 1)%data(1:1) .eq. 'f' ) then
          start_pos%x = start_pos%x + str2int(ctx(2*i))
          start_pos%y = start_pos%y + start_pos%aim * str2int(ctx(2*i))
       elseif ( ctx(2*i - 1)%data(1:1) .eq. 'u' ) then
          start_pos%aim = start_pos%aim - str2int(ctx(2*i))
       elseif ( ctx(2*i - 1)%data(1:1) .eq. 'd' ) then
          start_pos%aim = start_pos%aim + str2int(ctx(2*i))
       end if
    end do

    r = start_pos%x * start_pos%y
    return
  end function part2

end module day02


program main
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  use aoc, only: String, readfile, strfree, countlines, splitlinesby
  use day02
  implicit none

  integer :: nlines
  integer, allocatable :: numbers(:)
  character (len=30) :: filename
  integer :: part1_sol, part2_sol
  type(String) :: lines

  type(String), allocatable :: ctx(:)

  ! filename = 'test.txt'
  filename = 'input.txt'
  write(*,*) "Reading file: ", filename

  nlines = countlines(filename)
  write(*,*) "Number of lines: ", nlines
  allocate(numbers(nlines))

  call readfile(filename, lines)
  ctx = splitlinesby(lines, nlines, ' ')


  part1_sol = part1(ctx, nlines)
  write(*,*) "Part1: ", part1_sol

  part2_sol = part2(ctx, nlines)
  write(*,*) "Part2: ", part2_sol


  deallocate(numbers)
  deallocate(ctx)
  call strfree(lines)

end program main
