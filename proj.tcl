set ns [new Simulator]

#Colors for data flows
$ns color 1 Blue
$ns color 2 Green
$ns color 3 Yellow

#Trace file
set trFile [open out.tr w]
$ns trace-all $trFile
set namFile [open out.nam w]
$ns namtrace-all $namFile

#Finish
proc finish {} {
 global ns trFile namFile
 $ns flush-trace
 close $namFile
 close $trFile
 exit 0
}

#Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
set n11 [$ns node]

#Links between the nodes
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n3 1Mb 10ms DropTail
$ns duplex-link $n1 $n4 1Mb 10ms DropTail
$ns duplex-link $n3 $n2 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n4 $n8 1Mb 10ms DropTail
$ns duplex-link $n3 $n8 1Mb 10ms DropTail
$ns duplex-link $n8 $n11 1Mb 10ms DropTail
$ns duplex-link $n8 $n7 1Mb 10ms DropTail
$ns duplex-link $n7 $n11 1Mb 10ms DropTail
$ns duplex-link $n7 $n6 1Mb 10ms DropTail
$ns duplex-link $n8 $n9 1Mb 10ms DropTail
$ns duplex-link $n9 $n10 1Mb 10ms DropTail
#$ns queue-limit $n0 $n2 10

#Node position
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n3 orient right-up
$ns duplex-link-op $n1 $n4 orient right-down
$ns duplex-link-op $n3 $n2 orient up
$ns duplex-link-op $n4 $n5 orient down
$ns duplex-link-op $n4 $n8 orient right-up
$ns duplex-link-op $n3 $n8 orient right
$ns duplex-link-op $n8 $n11 orient right
$ns duplex-link-op $n7 $n11 orient right-down
$ns duplex-link-op $n8 $n7 orient up
$ns duplex-link-op $n7 $n6 orient up
$ns duplex-link-op $n8 $n9 orient down
$ns duplex-link-op $n9 $n10 orient down

$ns rtproto DV

#UDP connection
set udp1 [new Agent/UDP]
$ns attach-agent $n10 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n2 $null1
$ns connect $udp1 $null1
$udp1 set fid_ 1
#CBR over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR
$cbr1 set packet_size_ 500
#$cbr1 set rate_ 800kb

#UDP connection
set udp2 [new Agent/UDP]
$ns attach-agent $n6 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n0 $null2
$ns connect $udp2 $null2
$udp2 set fid_ 2
#CBR over UDP connection
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR
$cbr2 set packet_size_ 500
#$cbr2 set rate_ 800kb

#UDP connection
set udp3 [new Agent/UDP]
$ns attach-agent $n11 $udp3
set null3 [new Agent/Null]
$ns attach-agent $n5 $null3
$ns connect $udp3 $null3
$udp3 set fid_ 3
#VBR over UDP connection
set vbr [new Application/Traffic/Exponential]
$vbr set rate_ 600kb
$vbr set packet_size_ 280
$vbr set burst_time_ 150ms
$vbr set idle_time_ 100ms
$vbr attach-agent $udp3

#Scheduling
$ns rtmodel-at 1.5 down $n3 $n8
$ns rtmodel-at 1.8 down $n4 $n8
$ns rtmodel-at 2.2 up $n3 $n8
$ns rtmodel-at 3.2 up $n4 $n8
$ns at 0.0 "$cbr1 start"
$ns at 0.5 "$cbr2 start"
$ns at 0.8 "$vbr start"
$ns at 4.0 "$vbr stop"
$ns at 5.0 "$cbr1 stop"
$ns at 5.0 "$cbr2 stop"
$ns at 5.5 "finish"
$ns run
