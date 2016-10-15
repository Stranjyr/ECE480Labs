add_i $R0 <listStart> --store list address in R0
adde_r $S0 $ZERO $R0 --move from R0 to S0
adde_i $T0 x0 --temp
adde_i $T1 x0 --count
adde_i $T2 x0 --iter
--Variables set up
--start loop1
:loop1: adde_r $R0 $ZERO $T1
sube_i $R0 x63
jz $R0 <exit1>
adde_r $T0 $ZERO $T1
--loop2 setup
adde_r $T2 $ZERO $T1 -- iter = count
adde_i $T2 x1 --iter+=1
:loop2: adde_r $R0 $ZERO $T2
sube_i $R0 x64
jz $R0 <exit2>
lw $R0 $S0 $T0 --R0 = list[temp]
lw $R1 $S0 $T2 --R1 = list[iter]
sube_r $R0 $R0 $R1
jp $R0 <endif> --jp if R0 >= R1
adde_r $T0 $ZERO $T2 --temp = iter
:endif: jmp <loop2>
:exit2: lw $T2 $S0 $T1
lw $R0 $S0 $T0 --r0 = list[temp]
sw $R0 $S0 $T1 --list[count] = r0
lw $T2 $S0 $T0 --list[temp] = iter
jmp <loop1>
:exit1: jmp <exit1> --loop forever at end
:liststart: add $R0 x0 --filler, put data here