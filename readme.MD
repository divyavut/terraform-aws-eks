#### Cluster Upgrade
- blue group of nodes ---> current running
- green group of nodes ---> 

- it is better to announce downtime, you should not do any release or deployment or changes to any resources.
change the sg , so that only admin team bastion have access to cluster
1. create another node group green with same capacity..
2. cordon green nodes not to accept any pods 
2. upgrade control plane to 1.31
3. upgrade green also to 1.31
4. 
