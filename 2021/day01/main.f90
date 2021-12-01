function countlines(filename) result(n)
  implicit none

  character (len=10), intent(in) :: filename
  integer :: Reason
  integer, parameter :: read_unit = 9
  integer :: n

  n = 0

  ! opening the file for reading
  open (read_unit, file = filename)

  do
  read(read_unit,'(A)', IOSTAT=Reason)
  if (Reason > 0)  then
    exit
  else if (Reason < 0) then
    exit
  else
    n = n + 1
  end if
  end do

  close(read_unit)

  return
end function countlines


integer function part1(numbers, len)
  implicit none
  integer :: r 
  integer, intent(in) :: len
  integer, intent(in) :: numbers(len)
  integer :: i

  r = 0

  do i = 2,len
  if (numbers(i) > numbers(i-1)) then
    r = r + 1
  end if
  end do

  part1 = r
end function part1

function summation(numbers, len) result(v)
  implicit none
  integer, intent(in) :: len
  integer, dimension(:), intent(in) :: numbers
  integer, allocatable :: v(:)
  integer :: i
  integer :: n
  
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
  integer, external :: part1

  interface
    function summation(numbers, len) result(v)
      integer, intent(in) :: len
      integer, dimension(:), intent(in) :: numbers
      integer, allocatable :: v(:)
    end function
  end interface

  numbers2 = summation(numbers, len) 

  part2 = part1(numbers2, len-2)
end function part2

subroutine str2int(filename, arr, n)
  implicit none
  character(len=*), intent(in) :: filename
  integer, intent(in) :: n
  integer, dimension(n), intent(inout) :: arr
  integer :: stat
  integer :: read_unit = 9

  open (read_unit, file=filename)
  read(read_unit, *, iostat=stat) arr
  close(read_unit)
end subroutine str2int

program day01
  implicit none

  integer :: nlines
  integer, allocatable :: numbers(:)
  character (len=10) :: filename
  integer :: part1_sol, part2_sol

  integer :: countlines, part1, part2

  ! filename = 'test.txt'
  filename = 'input.txt'
  write(*,*) "Reading file: ", filename

  nlines = countlines(filename)

  write(*,*) "Number of lines: ", nlines

  allocate(numbers(nlines))

  call str2int(filename, numbers, nlines)

  part1_sol = part1(numbers, nlines)

  write(*,*) "Part1: ", part1_sol

  part2_sol = part2(numbers, nlines)
  write(*,*) "Part2: ", part2_sol

  deallocate(numbers)

end program day01
