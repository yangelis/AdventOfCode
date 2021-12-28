module day06
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  use aoc, only: String, VecSV, Veci32, readlines, split, new_veci32
  implicit none

contains

  function parse_init_state(lines) result(xs)
    type(String), intent(in) :: lines(1)
    integer(i32) :: xs(9)
    character(len=1) :: delim
    integer(i32), allocatable :: nums(:)
    type(VecSV) :: svs
    integer(i32) :: i, n
    logical, allocatable :: mask(:)

    delim = ','
    svs = split(lines(1), delim, 300)

    n = svs%n
    allocate(nums(n))

    do i = 1, n
       read(svs%data(i)%data(1:svs%data(i)%endp), *) nums(i)
    end do

    allocate(mask(n))
    mask = .false.

    xs = 0
    do i = 1, 9
       mask(:) = nums.eq.(i-1)
       xs(i) = count(mask)
    end do
  end function parse_init_state

  recursive function bin_expo(mat, n) result(c)
    integer(i64), intent(in) :: mat(9, 9)
    integer(i64), intent(in) :: n
    integer(i32)  :: i
    integer(i64) :: c(9, 9), temp(9, 9), ii(9, 9)

    ii = 0
    do i = 1, 9
       ii(i, i) = 1
    end do

    if (n == 0) then
       c = ii
    else
       c = bin_expo(mat, n/2_i64)
       if (mod(n, 2_i64) == 0) then
          c = matmul(c, c)
       else
          temp = matmul(c, c)
          c = matmul(mat, temp)
       end if
    end if

  end function bin_expo

  function evolve(xs, days) result(n)
    integer(i32), intent(in) :: xs(9)
    integer(i64), intent(in) :: days
    integer(i32) :: i
    integer(i64) :: x(9)
    integer(i64) :: m(9, 9), c(9, 9)
    integer(i64) :: n

    m = 0
    do i = 1, 8
       m(i, i+1) = 1
    end do
    m(7, 1) = 1
    m(9, 1) = 1

    c = bin_expo(m, days)

    x = matmul(c, xs)
    n = sum(x)
  end function evolve
end module day06

program main
  use day06
  implicit none
  BLOCK
    integer(i32) :: nlines
    integer(i64) :: p1, p2
    type(String), allocatable :: lines(:)
    character (len=30) :: filename
    integer(i32) :: xs(9)

    ! filename = 'test.txt'
    filename = 'input.txt'
    write(*, *) "Reading file: ", filename

    lines = readlines(filename)
    nlines = size(lines)

    xs = parse_init_state(lines)

    p1 = evolve(xs, 80_i64)
    write(*, *) "Part1: ", p1

    p2 = evolve(xs, 256_i64)
    write(*, *) "Part2: ", p2

  end BLOCK
end program main
