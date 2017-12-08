reset;
set P;#delivery man
set O;#origins
set D;#destinations
param person{P} >=0;
param supply{O} >=0;
param demand{D} >=0;


#check :sum{j in O} supply{j}>=sum{k in D} demand{k};

param cost{P,O,D} >=0;#shipment cost
var y{P,O,D}>=0;#decision variable

minimize Total_Cost: 
sum{i in P, j in O, k in D}y[i,j,k]*cost[i,j,k];

subject to Supply_con{j in O}:
sum{i in P, k in D}y[i,j,k]=supply[j];

subject to Demand_con{k in D}:
sum{i in P, j in O}y[i,j,k]=demand[k];
