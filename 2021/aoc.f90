module aoc
  use iso_fortran_env, only:i8 => int8, i16 => int16, i32 => int32, i64 => int64, &
       f32 => real32, f64 => real64, f128 => real128
  implicit none

  public String, new_str, strfree, readfile, countlines



  type, public :: String
     character(len=:), allocatable :: str
     integer :: str_size
   contains
     final :: str_dealloc
  end type String

contains
  type(String) function new_str(s)
    character(len=:), allocatable :: s

    new_str%str = s
    new_str%str_size = len(s)

  end function new_str


  ! NOTE: gfortran has issues with final functions
  ! that's why we have strfree
  subroutine str_dealloc(this)
    type(String), intent(inout) :: this

    if (allocated(this%str)) deallocate (this%str)
  end subroutine str_dealloc

  subroutine strfree(str)
    implicit none
    type(String), intent(inout) :: str

    deallocate(str%str)
    str%str_size = 0
  end subroutine strfree


  subroutine readfile(filename, buffer)
    implicit none
    integer :: rc, fd = 99, file_size
    character (len=30), intent(in) :: filename
    type(String), intent(out) :: buffer
    logical :: file_exists

    open (access='stream', action='read', file=filename, &
         form='unformatted', iostat=rc, unit=fd)

    if (rc /= 0) stop 'Error: opening file failed'

    inquire (exist=file_exists, file=filename, size=file_size)

    allocate(character(len=file_size) :: buffer%str)
    buffer%str_size = file_size

    if (rc /= 0) stop 'Error: open failed'
    read (fd, iostat=rc) buffer%str
    close (fd)
  end subroutine readfile

  function countlines(filename) result(n)
    implicit none

    character (len=10), intent(in) :: filename
    integer :: stat
    integer, parameter :: read_unit = 9
    integer :: n

    n = 0

    ! opening the file for reading
    open (read_unit, file = filename)

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

end module aoc
