BEGIN {
  enq = 0;
  drop = 0;
  receive = 0;
  start = 0;
  recvdSize = 0;
  startTime = 0;
  stopTime = 0;
}
{
  event = $1
  fromNode = $3
  toNode = $4
  byte = $6
  fid = $8
  time = $2
  
  #a
  if(event == "+") enq++;
  #b
  if(event == "d" && fromNode == "8") drop++;
  #c
  if(event == "r" && toNode == "3") receive += byte;
  #d
  if(event == "r" && fid == "2") {
    if(start == 0){
      start = 1;
      startTime = time;
    }
    recvdSize += byte;
    stopTime = time;
  }
}

END {
  printf("Total number of “ENQ” events :   %d\n" ,enq);
  printf("The number of packets that node8 drops :   %d\n" ,drop);
  printf("Total number of bytes that node3 receives :   %d\n" ,receive);
  printf("The throughput[bps] of fid = 2 :   %.2f\n" ,(recvdSize*8)/(stopTime-startTime));
}
