reset;
set P;#delivery man
set O;#origins
set D;#destinations
param person{P} >=0;
param supply{O} >=0;
param demand{D} >=0;


#check :sum{j in O} supply{j}=sum{k in D} demand{k};

param cost{P,O} >=0;#shipment cost
param cost{O,D} >=0;#shipment cost
param cost{D,O} >=0;#shipment cost
param cost{D,P} >=0;#shipment cost


var x{P,O}>=0;#decision variable
var x{O,D}>=0;#decision variable
var x{D,O}>=0;#decision variable
var x{D,P}>=0;#decision variable


minimize Total_Cost: 
sum{i in P, j in O}x[i,j]*cost[i,j]+sum{j in O, k in D}x[j,k]*cost[j,k]+sum{k in D, j in O}x[k,j]*cost[k,j]+sum{k in D, i in P}x[k,i]*cost[k,i];

subject to Supply_con{j in O}:
sum{i in P}x[i,j]+sum{k in D}x[k,j]=supply[j];

subject to Demand_con{k in D}:
sum{j in O}x[j,k]=demand[k];

subject to Person_con{i in P}:
sum{k in D}x[k,i]=sum{j in O}x[j,i];