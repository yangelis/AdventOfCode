FC       := gfortran

day01 : main.f90
	$(FC) -Wintrinsics-std -Wall -Wextra -ggdb -o $@ $<



.PHONY: clean
clean:
	rm -f *.o day01
