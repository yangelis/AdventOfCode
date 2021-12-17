module day15
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  use aoc, only: String, readlines
  implicit none
contains

  function parsegrid(nlines, lines) result(grid)
    integer(i32), intent(in) :: nlines
    type(String), intent(in) :: lines(nlines)
    integer(i32), allocatable :: grid(:, :)
    integer(i32) :: m, i, j

    m = lines(1)%str_size
    allocate(grid(nlines, m))

    do i = 1, nlines
       do j = 1, m
          read(lines(i)%data(j:j), *) grid(i, j)
       end do
    end do
  end function parsegrid

  subroutine min_el(queue_size, queue, sq)
    integer(i32), intent(in) :: queue_size
    integer(i32), intent(inout) :: queue(4, queue_size)
    integer(i32), intent(inout) :: sq(3)
    integer(i32) :: i, imin, vmin

    imin = 1
    vmin = 9999
    do i=1,queue_size
       if (queue(1, i) < vmin .and. queue(4, i) == 1) then
          vmin = queue(1, i)
          imin = i
       end if
    end do

    queue(4, imin) = 0
    sq = queue(1:3, imin)

  end subroutine min_el

  function dijkstra(n, m, grid) result(c)
    integer(i32), intent(in) :: n, m
    integer(i32), intent(in) :: grid(n, m)
    integer(i32) :: qc, k, ii, jj, queue_size, queue_tot_size
    integer(i32) :: c
    integer(i32) :: source(2), destination(2)
    integer(i32), allocatable :: queue(:, :)
    integer(i32), allocatable :: visited_set(:, :)
    integer(i32), allocatable :: distances(:, :)
    integer(i32) :: sq(3), new_distance
    integer(i32) :: neighbors(2, 4)

    neighbors(:, 1) = [1, 0]
    neighbors(:, 2) = [0, 1]
    neighbors(:, 3) = [0, -1]
    neighbors(:, 4) = [-1, 0]

    source = [1, 1]
    destination = [n, m]

    allocate(queue(4, n*m))
    queue = 0
    ! set last to 1 for valid
    ! or 0 to ignore
    queue_tot_size = n*m
    queue_size = 1
    qc = 1
    queue(:, qc) = [0, source, 1]

    allocate(visited_set(n, m))
    visited_set = 0

    allocate(distances(n, m))
    distances(1, 1) = 0
    distances = 9999


    c = -1
    do while(queue_size > 0)
       call min_el(qc, queue, sq)
       queue_size = queue_size - 1

       if ( sq(2) == destination(1) .and. sq(3) == destination(2) ) then
          c = sq(1)
          exit
       end if

       if (visited_set(sq(2), sq(3)) == 1) cycle

       visited_set(sq(2), sq(3)) = 1

       do k = 1, 4
          ii = sq(2) + neighbors(1, k)
          jj = sq(3) + neighbors(2, k)

          if (1 <= ii .and. ii <= n .and. 1 <= jj .and. jj <= m) then
             if (visited_set(ii, jj) == 0) then
                new_distance = sq(1) + grid(ii, jj)
                ! if (distances(ii, jj) /= 9999) then
                   if (new_distance < distances(ii, jj)) then
                      distances(ii, jj) = new_distance
                      queue_size = queue_size + 1
                      qc = qc + 1
                      queue(:, qc) = [new_distance, ii, jj, 1]
                   end if
                ! else
                !    distances(ii, jj) = new_distance
                !    queue_size = queue_size + 1
                !    queue(:, queue_size) = [new_distance, ii, jj, 1]
                ! end if
             end if
          end if
       end do
    end do

  end function dijkstra

end module day15

program main
  use day15
  implicit none

  BLOCK
    integer(i32) :: nlines, p1, p2
    integer(i32) :: i, j
    type(String), allocatable :: lines(:)
    character (len=30) :: filename
    integer(i32), allocatable :: grid(:, :), grid2(:, :)
    integer(i32) :: sh(2)

    ! filename = 'test.txt'
    filename = 'input.txt'
    write(*, *) "Reading file: ", filename

    lines = readlines(filename)
    nlines = size(lines)

    grid = parsegrid(nlines, lines)
    sh = shape(grid)

    ! do p1 = 1, sh(1)
    !    do p2 = 1, sh(2)
    !       write(*, "(i1)", advance="no") grid(p1, p2)
    !    end do
    !       write(*, *)
    ! end do

    p1 = dijkstra(sh(1), sh(2), grid)
    write(*, *) "Part1: ", p1


    allocate(grid2(5*sh(1), 5*sh(2)))
    grid2(1:sh(1), 1:sh(2)) = grid
    do i=1,4
       do j=1,sh(1)
          grid2(j, i*sh(2)+1:(i+1)*sh(2)) = mod(grid2(j, (i-1)*sh(2)+1:i*sh(2)), 9) + 1
       end do
    end do

    do i=1,4
       do j=1,sh(2)
          grid2(i*sh(1)+1:(i+1)*sh(1), j) = mod(grid2((i-1)*sh(1)+1:i*sh(1), j), 9) + 1
       end do
    end do

    do i=1,4
       do j=1,4
          grid2(i*sh(1)+1:(i+1)*sh(1), j*sh(2)+1:(j+1)*sh(2)) = mod(grid2(i*sh(1)+1:(i+1)*sh(1), (j-1)*sh(2)+1:j*sh(2)), 9) + 1
       end do
    end do

    sh = shape(grid2)
    p2 = dijkstra(sh(1), sh(2), grid2)
    write(*, *) "Part2: ", p2

  end BLOCK
end program main
