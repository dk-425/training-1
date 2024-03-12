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


'''
f = open("demofile5.txt", "w")


for i in range(8192):
    
    f.write(str(i)+'\n')
    
f.close()
'''
#int=2,frac=14
f1 = open('inputfile.csv', 'r')
f2 = open("outputfile.txt", "w")



for i in f1:
    		
    u,v = float(i.split(',')[0]), float(i.split(',')[1])

    print(u,v)
    if (u<0 or v<0):
        integer=1
        fractional=14
        s=2**14
        q=round(float(u)*s)
        p=round(float(v)*s)
        if (u<0):
           s1="1"
           q=-1*q
        else:
           s1="0"
        if (v<0):
           s2="1"
           p=-1*p
        else:
           s2="0"
        f2.write(s1+','+str(q)+','+s2+','+str(p)+'\n')
    else:
        integer=2
        fractional=14
        s=2**14
        q=round(float(u)*s)
        p=round(float(v)*s)
        s1="0"
        s2="0"
        f2.write(s1+','+str(q)+','+s2+','+str(p)+'\n')


    
  #  y.append(int(u)+int(v))
f1.close()
f2.close()