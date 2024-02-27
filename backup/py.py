'''import random
f = open("demofile2.txt", "w")


for i in range(8192):
    y=i+1;
    x=num = random.randrange(1, 101, 2)  # Odd numbers between 1 and 100

    if (y%64==0):
       j=1;
    else:
       j=0;
    f.write(str(x)+','+str(j)+'\n')
    
f.close()
'''
'''
length=64
k=2
x=[]
y=[]
p=0

with open('demofile3.txt', 'r') as f:
	for i in f:
    		
    		u = i.split(',')[0]
    		v = i.split(',')[1]
    		y.append(int(u)+int(v))
	

z=open('demofile4.txt', 'w')
for i in range(len(y)):
 z.write(str(y[i])+'\n')
	'''
	
f = open("demofile5.txt", "w")


for i in range(8192):
    
    f.write(str(i)+'\n')
    
f.close()
