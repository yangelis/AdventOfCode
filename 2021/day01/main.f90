module day01
  use aoc, only: String
  implicit none
contains
  integer function part1(numbers, len)
    integer :: i
    integer, intent(in) :: len
    integer, intent(in) :: numbers(len)

    part1 = 0
    do i = 2,len
       if (numbers(i) > numbers(i-1)) then
          part1 = part1 + 1
       end if
    end do

  end function part1

  function summation(numbers, len) result(v)
    implicit none
    integer, intent(in) :: len
    integer, dimension(:), intent(in) :: numbers
    integer, allocatable :: v(:)
    integer :: i, n

    n = len - 2

    allocate(v(n))
    do i =1, n
       v(i) = numbers(i) + numbers(i+1) + numbers(i+2)
    end do
  end function summation

  integer function part2(numbers, len)
    implicit none
    integer, intent(in) :: len
    integer, intent(in) :: numbers(len)
    integer :: numbers2(len-2)

    numbers2 = summation(numbers, len)

    part2 = part1(numbers2, len-2)
  end function part2

  subroutine str2int(str, arr, n)
    use aoc, only: String, readfile
    implicit none
    type(String), intent(in) :: str
    integer, intent(in) :: n
    integer, dimension(n), intent(inout) :: arr
    integer :: stat

    read(str%data, *, iostat=stat) arr
  end subroutine str2int

  subroutine file2int(filename, arr, n)
    implicit none
    character(len=*), intent(in) :: filename
    integer, intent(in) :: n
    integer, dimension(n), intent(inout) :: arr
    integer :: stat
    integer :: read_unit = 9

    open(read_unit, file=filename)
    read(read_unit, *, iostat=stat) arr
    close(read_unit)
  end subroutine file2int

end module day01

program main
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  use aoc, only: String, readfile, strfree, countlines
  use day01
  implicit none

  integer :: nlines
  integer, allocatable :: numbers(:)
  character (len=30) :: filename
  integer :: part1_sol, part2_sol
  type(String) :: lines

  ! filename = 'test.txt'
  filename = 'input.txt'
  write(*,*) "Reading file: ", filename

  nlines = countlines(filename)
  write(*,*) "Number of lines: ", nlines
  allocate(numbers(nlines))

  call readfile(filename, lines)
  call str2int(lines, numbers, nlines)

  part1_sol = part1(numbers, nlines)

  write(*,*) "Part1: ", part1_sol

  part2_sol = part2(numbers, nlines)
  write(*,*) "Part2: ", part2_sol

  deallocate(numbers)
  call strfree(lines)

end program main
