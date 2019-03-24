#creating an array of figure handles:
# data<-array(c(y1,y2), c(p,2,2))

euclid<-function(p1,p2){		#euclidean distance between two points
	d<-0
	for(m in 1:length(p1)){
		d<-d+(p1[m]-p2[m])^2
		}
	euclid<-sqrt(d)
	}

getL<-function(y){
	p<-dim(y)[1]
	L<-matrix(0,p+3,p+3)
	for(i in 1:(p-1)){
		for(j in (i+1):p){
			d<-euclid(y[i,],y[j,])
			r<-d^2*log(d^2)
			L[i,j]<-r
			L[j,i]<-L[i,j]
			}
		}
	L[p+1,1:p]<-1.0
	L[p+2,1:p]<-y[,1]
	L[p+3,1:p]<-y[,2]
	L[1:p,p+1]<-1.0
	L[1:p,p+2]<-y[,1]
	L[1:p,p+3]<-y[,2]
	return(L)
	}

tpsaffine<-function(x, Linv){
	p<-dim(x)[1]
	a<-matrix(0,3,2)
	rownames(a)<-c('a1','ax','ay')
	a[1,1]<-Linv[p+1,1:p]%*%x[1:p,1] #a1.x
	a[2,1]<-Linv[p+2,1:p]%*%x[1:p,1] #ax.x
	a[3,1]<-Linv[p+3,1:p]%*%x[1:p,1] #ay.x
	
	a[1,2]<-Linv[p+1,1:p]%*%x[1:p,2] #a1.y
	a[2,2]<-Linv[p+2,1:p]%*%x[1:p,2] #ax.y
	a[3,2]<-Linv[p+3,1:p]%*%x[1:p,2] #ay.y
	return(a)
	}
	
tpsnonaffine<-function(x, Linv){
	p<-dim(x)[1]
	w<-matrix(0,p,2)
	w<-Linv[1:p,1:p]%*%x
	}

tps.point<-function(a,w,y,pt){		#pt is the 2D cartesion point, y is figure to deform
	p<-dim(y)[1]
	loc<-matrix(0,p,2)
	loc[,1]<-as.numeric(pt[1])
	loc[,2]<-as.numeric(pt[2])
	rvec<- sqrt((y[,1]-loc[,1])^2 + (y[,2]-loc[,2])^2)
	uvec<-rvec^2*log((rvec+1e-16)^2)
	sum<-t(w)%*%uvec
	xp<-a[1,1]+a[2,1]*loc[1,1]+a[3,1]*loc[1,2]+sum[1]
	yp<-a[1,2]+a[2,2]*loc[1,1]+a[3,2]*loc[1,2]+sum[2]
	return(c(xp,yp))
	}
	
tps.outline<-function(x,ol,s=1){
	# x is the target in the format of a matrix with p rows and 2 columns
	# ol is the list of ol coordinates
	# s is a scale factor (make this big if the ol coordinates are big)
	p<-dim(x)[1]		# number of landmarks
	k<-length(ol)-1		# number of outline segments
	y<-ol[[1]]/s
	Linv<-solve(getL(y))
	w<-tpsnonaffine(x, Linv) 		#affine component
	a<-tpsaffine(x,Linv)		#unifform component
	for(i in 1:k){
		seg<-i+1
		for(j in 1:dim(ol[[seg]])[1]){
			pt<-tps.point(a,w,y,ol[[seg]][j,]/s)
			if(j>1){
				segments(opt[1],opt[2],pt[1],pt[2])
				}
			opt<-pt
			}
		}
	}
	
tps<-function(x,y, gridlines=20){		#x is the target, y is the figure that is deformed
	p<-dim(x)[1]
	where<-numeric(2)
	loc<-matrix(0,p,2)
	Linv<-solve(getL(y))
	w<-tpsnonaffine(x, Linv) 		#affine component
	a<-tpsaffine(x,Linv)		#unifform component
	#draw grid
	extra<-0.1
	minx<-min(y[,1])-extra*(max(y[,1])-min(y[,1]))
	miny<-min(y[,2])-extra*(max(y[,2])-min(y[,2]))
	maxx<-max(y[,1])+extra*(max(y[,1])-min(y[,1]))
	maxy<-max(y[,2])+extra*(max(y[,2])-min(y[,2]))
	dx<-maxx-minx
	dy<-maxy-miny
	gridinterval<-max(dx,dy)/(gridlines-1)
	hlines<-ceiling(dy/gridinterval)+1
	vlines<-ceiling(dx/gridinterval)+1
	gridx<-matrix(0, hlines, vlines)
	gridy<-matrix(0,hlines,vlines)
	for(i in 1:(hlines)){
		iy<-i-1
		for(j in 1:(vlines)){
			ix<-j-1
			loc[,1]<-minx+ix*gridinterval
			loc[,2]<-miny+iy*gridinterval
			rvec<- sqrt((y[,1]-loc[,1])^2 + (y[,2]-loc[,2])^2)
			uvec<-rvec^2*log((rvec+1e-16)^2)
			sum<-t(w)%*%uvec
			xp<-a[1,1]+a[2,1]*loc[1,1]+a[3,1]*loc[1,2]+sum[1]
			yp<-a[1,2]+a[2,2]*loc[1,1]+a[3,2]*loc[1,2]+sum[2]
			gridx[i,j]<-xp
			gridy[i,j]<-yp
			}
		}
	#draw points & grid
	extra<-0.2
	hmin<-min(x[,1])-extra*(max(x[,1])-min(x[,1]))
	hmax<-max(x[,1])+extra*(max(x[,1])-min(x[,1]))
	vmin<-min(x[,2])-extra*(max(x[,2])-min(x[,2]))
	vmax<-max(x[,2])+extra*(max(x[,2])-min(x[,2]))
	plot(x[,1], x[,2], type='p', asp=1, xlim=c(hmin, hmax),		ylim=c(vmin,vmax))
	for(i in 1:hlines){
		lines(gridx[i,], gridy[i,])
		}
	for(i in 1:vlines){
		lines(gridx[,i], gridy[,i])
		}
	#draw outline
	
	}