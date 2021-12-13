module day03
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  use aoc, only: Pair, String, str2int, readlines, countlines
  implicit none

contains

  subroutine binary2int(nlines, lines, nums)
    integer(i32), intent(in) :: nlines
    type(String), intent(in) :: lines(nlines)
    integer(i32), intent(inout), allocatable :: nums(:)
    integer(i32) :: i

    allocate(nums(nlines))
    do i = 1, nlines
       read(lines(i)%data,'(B32)') nums(i)
    end do
  end subroutine binary2int

  subroutine onesandzeros(n, ones, zeros, nlines, lines)
    integer(i32), intent(in) :: n
    integer(i32), intent(inout) :: ones(n), zeros(n)
    integer(i32), intent(in) :: nlines
    type(String), intent(in) :: lines(nlines)
    integer(i32) :: i, j

    ones = 0
    zeros = 0

    COLS: do i = 1, n
       ROWS: do j = 1, nlines
          select case (lines(j)%data(i:i))
          case ('0')
             zeros(i) = zeros(i) + 1
          case ('1')
             ones(i) = ones(i) + 1
          end select
       end do ROWS
    end do COLS
  end subroutine onesandzeros

  function part1(nlines, lines) result(rates)
    integer(i32), intent(in) :: nlines
    type(String), intent(in) :: lines(nlines)
    integer(i32) :: rates
    integer(i32) :: i, n
    integer(i32), allocatable :: ones_per_col(:), zeros_per_col(:)
    type(String) :: gamma_rate_str, epsilon_rate_str
    integer(i32) :: gamma_rate, epsilon_rate

    n = lines(1)%str_size
    allocate(ones_per_col(n))
    allocate(zeros_per_col(n))
    ones_per_col = 0
    zeros_per_col = 0
    call onesandzeros(n, ones_per_col, zeros_per_col, nlines, lines)

    allocate(character(len=n) :: gamma_rate_str%data)
    allocate(character(len=n) :: epsilon_rate_str%data)
    gamma_rate_str%str_size = n
    epsilon_rate_str%str_size = n

    do i = 1, n
       if (ones_per_col(i) > zeros_per_col(i)) then
          gamma_rate_str%data(i:i) = '1'
          epsilon_rate_str%data(i:i) = '0'
       else
          gamma_rate_str%data(i:i) = '0'
          epsilon_rate_str%data(i:i) = '1'
       end if
    end do

    read(gamma_rate_str%data, '(B32)') gamma_rate
    read(epsilon_rate_str%data, '(B32)') epsilon_rate

    rates = gamma_rate * epsilon_rate
  end function part1

  function countindices(nlines, indices) result(n)
    integer(i32), intent(in) :: nlines
    type(Pair), intent(in) :: indices(nlines)
    integer(i32) :: i, n

    n = 0
    do i = 1, nlines
       if (indices(i)%second .ne. 0) n = n + 1
    end do
  end function countindices

  function part2(nlines, lines) result(rates)
    integer(i32), intent(in) :: nlines
    type(String), intent(in) :: lines(nlines)
    integer(i32) :: rates
    integer(i32) :: i, j, ii, n, ids
    integer(i32), allocatable :: ones_per_col(:), zeros_per_col(:)
    type(String) :: lines_cp1(nlines), lines_cp2(nlines)
    type(Pair) :: indices(nlines)
    character(len=1) :: cmp
    integer(i32) :: o2_id, co2_id, o2_rate, co2_rate

    n = lines(1)%str_size
    allocate(ones_per_col(n))
    allocate(zeros_per_col(n))
    ones_per_col = 0
    zeros_per_col = 0

    lines_cp1 = lines

    do i = 1, nlines
       indices(i)%first = i
       indices(i)%second = i
    end do

    cmp = '2'
    COLS1: do i = 1, n
       call onesandzeros(n, ones_per_col, zeros_per_col, nlines, lines_cp1)
       if (ones_per_col(i) >= zeros_per_col(i)) then
          cmp = '1'
       elseif (ones_per_col(i) < zeros_per_col(i)) then
          cmp = '0'
       end if

       ROWS1: do j = 1, nlines
          if (indices(j)%second .ne. 0 .and. cmp .ne. lines_cp1(j)%data(i:i)) then
             do ii = 1, n
                lines_cp1(j)%data(ii:ii) = '2'
             end do
             ids = countindices(nlines, indices)
             if (ids == 1) then
                exit ROWS1
             end if
             indices(j)%second = 0
          end if
       end do ROWS1
    end do COLS1

    do j = 1, nlines
       if (indices(j)%second .ne. 0) o2_id = j
    end do
    read(lines(o2_id)%data, '(B32)') o2_rate

    do i = 1, nlines
       indices(i)%second = i
    end do

    lines_cp2 = lines
    cmp = '2'
    COLS2: do i = 1, n
       call onesandzeros(n, ones_per_col, zeros_per_col, nlines, lines_cp2)
       if (ones_per_col(i) < zeros_per_col(i)) then
          cmp = '1'
       elseif (ones_per_col(i) >= zeros_per_col(i)) then
          cmp = '0'
       end if

       ROWS2: do j = 1, nlines
          if (indices(j)%second .ne. 0 .and. cmp .ne. lines_cp2(j)%data(i:i)) then
             do ii = 1, n
                lines_cp2(j)%data(ii:ii) = '2'
             end do
             ids = countindices(nlines, indices)
             if (ids == 1) then
                exit ROWS2
             end if
             indices(j)%second = 0
          end if
       end do ROWS2
    end do COLS2

    do j = 1, nlines
       if (indices(j)%second .ne. 0) co2_id = j
    end do
    read(lines(co2_id)%data, '(B32)') co2_rate

    rates = o2_rate * co2_rate
  end function part2

end module day03


program main
  use day03
  implicit none

  integer(i32) :: nlines, p1, p2
  type(String), allocatable :: lines(:)
  character (len=30) :: filename

  ! filename = 'test.txt'
  filename = 'input.txt'
  write(*, *) "Reading file: ", filename

  lines = readlines(filename)
  nlines = size(lines)

  p1 = part1(nlines, lines)
  write(*, *) "Part1: ", p1

  p2 = part2(nlines, lines)
  write(*, *) "Part2: ", p2

  deallocate(lines)
end program main
