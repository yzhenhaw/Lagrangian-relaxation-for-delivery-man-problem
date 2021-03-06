reset;
set P;#delivery man
set O;#origins
set D;#destinations
param person{P} >=0;
param supply{O} >=0;
param demand{D} >=0;


#check :sum{j in O} supply{j}=sum{k in D} demand{k};

param cost1{P,O} >=0;#shipment cost
param cost2{O,D} >=0;#shipment cost
param cost3{D,O} >=0;#shipment cost
param cost4{D,P} >=0;#shipment cost
param olb{O}>=0;
param oub{O}>=0;
param dlb{D}>=0;
param dub{D}>=0;
param timeod{O,D}>=0;
param timedo{D,O}>=0;

var x1{P,O}>=0;#decision variable
var x2{O,D}>=0;#decision variable
var x3{D,O}>=0;#decision variable
var x4{D,P}>=0;#decision variable
var to{O}>=0;
var td{D}>=0;


minimize Total_Cost: 
sum{i in P, j in O}x1[i,j]*cost1[i,j]+sum{j in O, k in D}x2[j,k]*cost2[j,k]+sum{k in D, j in O}x3[k,j]*cost3[k,j]+sum{k in D, i in P}x4[k,i]*cost4[k,i];



subject to Person_c{i in P}:
sum{j in O}x1[i,j]<=person[i];

subject to Person_c2{i in P}:
sum{j in O}x1[i,j]>=sum{k in D}x4[k,i];


subject to Supply_out{j in O}:
sum{k in D}x2[j,k]=supply[j];

subject to Supply_in{j in O}:
sum{i in P}x1[i,j]+sum{k in D}x3[k,j]=supply[j];


subject to Demand_con{k in D}:
sum{j in O}x2[j,k]=demand[k];

subject to Demand_capcity{k in D}:
sum{j in O}x3[k,j]<=sum{j in O}x2[j,k];

subject to demand_out{k in D}:
sum{j in O}x2[j,k]=sum{i in P}x4[k,i]+sum{j in O}x3[k,j];

#time window

subject to demand_time_lb{k in D}:
td[k]>=dlb[k];

subject to demand_time_ub{k in D}:
td[k]<=dub[k];

subject to demand_time{j in O, k in D}:
to[j]+timeod[j,k]-td[k]<=(dub[k]+timeod[j,k]-dlb[k])*(1-x2[j,k]);

subject to origin_time_lb{j in O}:
to[j]>=olb[j];

subject to demand_time_ub{j in O}:
to[j]<=oub[j];

subject to demand_time{k in D, j in O}:
td[k]+timedo[k,j]-to[j]<=(oub[j]+timedo[k,j]-olb[j])*(1-x3[k,j]);

#subject to Capacity{j in O,k in D}:
#x2[j,k]<=30;
#subject to Capacity2{j in O,k in D}:
#x3[k,j]<=30;



