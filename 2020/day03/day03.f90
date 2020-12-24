function printer(map, rows, cols)
  implicit none
  character (len=1), dimension(323,31), intent(in) :: map
  integer, intent(in) :: rows, cols
  integer :: i, j
  integer :: printer

  do i = 1,rows
     print *, (map(i, j), j=1, cols)
  end do

  return
end function printer
! ==========================================================
integer function part1(map, rows, cols)
  implicit none
  character (len=1), dimension(323,31), intent(in) :: map
  character (len=1) :: position
  integer, intent(in) :: rows, cols
  integer :: i, j
  integer :: tree_counter

  i = 1
  j = 0
  tree_counter = 0

  do while (i <= rows )
     position = map(i, modulo(j, cols) + 1)
     if (position == '#') then
        tree_counter = tree_counter + 1
     end if
     i = i + 1
     j = j + 3
  end do

  part1 = tree_counter
  return
end function part1
! ==========================================================
integer function part2(map, rows, cols, istep, jstep)
  implicit none
  character (len=1), dimension(323,31), intent(in) :: map
  integer, intent(in) :: rows, cols, istep, jstep
  integer :: i, j, tree_counter
  character (len=1) :: position

  i = 1
  j = 0
  tree_counter = 0

  do while (i <= rows )
     position = map(i, modulo(j, cols) + 1)
     if (position == '#') then
        tree_counter = tree_counter + 1
     end if
     i = i + istep
     j = j + jstep
  end do


  part2 = tree_counter
  return
end function part2
! ==========================================================
program day03
  implicit none

  integer :: Reason
  integer :: columns
  character (len=80) :: filename
  character (len=1), dimension(323,31) :: row
  integer :: i, j, lines
  integer :: trees
  integer, external :: printer, part1, part2
  integer :: direction1, direction2, direction3
  integer :: direction4, direction5

  i = 1
  lines = 0
  columns = 31
  trees = 0

  ! read(*,*) filename
  filename = 'input.txt'
  write(*,*) filename
  ! opening the file for reading
  open (9, file = filename)

  do
     read(9,'(31A)', IOSTAT=Reason) (row(i, j), j=1,columns)
     i = i + 1
     if (Reason > 0)  then
        write(*,*) 'fucky wucky \n'
        exit
     else if (Reason < 0) then
        write(*,*) 'End of file reached'
        exit
     else
        lines = lines + 1
     end if
  end do

  write(*,*) 'Read no of lines:',lines

  trees = part1(row, lines, columns)
  write(*,*) 'Part1:', trees

  direction1 = part2(row, lines, columns, 1, 1)
  direction2 = part2(row, lines, columns, 1, 3)
  direction3 = part2(row, lines, columns, 1, 5)
  direction4 = part2(row, lines, columns, 1, 7)
  direction5 = part2(row, lines, columns, 2, 1)


  write(*,*) 'Part2: ', direction1 * direction2 * direction3 * direction4 * &
       & direction5


  close(1)
end program day03
