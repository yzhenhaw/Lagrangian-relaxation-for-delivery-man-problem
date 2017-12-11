reset;
set P;#delivery man
set O;#origins
set D;#destinations
param person{P} >=0;
param supply{O} >=0;
param demand{D} >=0;


param costpo{P,O} >=0;
param costod{O,D} >=0;
param costdo{D,O} >=0;
param costdp{D,P} >=0;
param olb{O}>=0;
param oub{O}>=0;
param dlb{D}>=0;
param dub{D}>=0;
param timeod{O,D}>=0;
param timedo{D,O}>=0;
param mult{O,D}>=0;


var ypo{P,O}>=0, <=1; #decision variable
var yod{O,D}>=0, <=1; #decision variable
var ydo{D,O}>=0, <=1;#decision variable
var ydp{D,P}>=0, <=1;#decision variable
var to{O}>=0;
var td{D}>=0;

minimize Total_Cost: 
sum{i in P, j in O}ypo[i,j]*costpo[i,j]+sum{j in O, k in D}yod[j,k]*costod[j,k]+sum{k in D, j in O}ydo[k,j]*costdo[k,j]+sum{k in D, i in P}ydp[k,i]*costdp[k,i];

minimize Total_Cost_LR: 
sum{i in P, j in O}ypo[i,j]*costpo[i,j]+sum{j in O, k in D}yod[j,k]*costod[j,k]+sum{k in D, j in O}ydo[k,j]*costdo[k,j]+sum{k in D, i in P}ydp[k,i]*costdp[k,i]+sum{j in O, k in D}mult[j,k]*(to[j]+timeod[j,k]-td[k]-(dub[k]+timeod[j,k]-dlb[k])*(1-yod[j,k]));

subject to Supply_con{j in O}:
sum{i in P}ypo[i,j]+sum{k in D}ydo[k,j]=1;

subject to Demand_con{k in D}:
sum{j in O}yod[j,k]=1;

subject to Person_con{i in P}:
sum{k in D}ydp[k,i]=1;

subject to Person_out_con{i in P}:
sum{j in O}ypo[i,j]=1;

subject to Demand_out_con{k in D}:
sum{j in O}ydo[k,j]+sum{i in P}ydp[k,i]=1;

subject to Supply_out_con{j in O}:
sum{k in D}yod[j,k]=1;

#time window

subject to demand_time_lb{k in D}:
td[k]>=dlb[k];

subject to demand_time_ub{k in D}:
td[k]<=dub[k];

subject to demand_time{j in O, k in D}:
to[j]+timeod[j,k]-td[k]<=(dub[k]+timeod[j,k]-dlb[k])*(1-yod[j,k]);

subject to origin_time_lb{j in O}:
to[j]>=olb[j];

subject to origin_time_ub{j in O}:
to[j]<=oub[j];

subject to origin_time{k in D, j in O}:
td[k]+timedo[k,j]-to[j]<=(oub[j]+timedo[k,j]-olb[j])*(1-ydo[k,j]);
