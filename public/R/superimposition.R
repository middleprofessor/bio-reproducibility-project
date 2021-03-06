library(shapes)

matrix2array<-function(x){
	#x is a matrix of n rows and p*2 columns of shape data
	#the output, y, is in the format for plotshapes in the shapes package
	#dim=p, 2, n where p=#landmarks and n=#figurees
	n<-dim(x)[1]
	p<-dim(x)[2]/2
	y<-array(0,c(p,2,n))
	for(i in 1:n){
		l<-0
		for(j in 1:p){
			l<-l+1
			y[j,1,i]<-x[i,l]
			l<-l+1
			y[j,2,i]<-x[i,l]
			}
		}
	return(y)
	}
	
array2matrix<-function(x){
	#converts array to matrix - see matrix2array
	n<-dim(x)[3]
	p<-dim(x)[1]
	y<-matrix(0,n,p*2)
	for(i in 1:n){
		l<-0
		for(j in 1:p){
			l<-l+1
			y[i,l]<-x[j,1,i]
			l<-l+1
			y[i,l]<-x[j,2,i]
			}
		}
	return(y)
	}

read.QI.file<-function(fn=''){
	#the output is in matrix format - see matrix2array above
	lines<-readLines(fn)
	lines.split1<-strsplit(lines,"\t")[1:4]
	scale<-as.numeric(lines.split1[[4]][1])
	l<-length(lines)-5
	data<-matrix(0,l,4)
	for(i in 1:l){
		data[i,]<-as.integer((strsplit(lines,"\t")[i+5])[[1]][1:4])
		}
	colnames(data)<-c('frame','lm','x','y')
	data[data==-9999]<-NA
	data[,3:4]<-data[,3:4]/scale #data is the scaled QI file in the same format as the QI file
	
	#reshape QI file to an array as in plot shapes
	# with n figures, p landmarks, and k=2 dimensions
	n<-data[l,1]
	p<-data[l,2] #note this assumes all figures have p landmarks
	y<-array(0,c(p,2,n))
	for(i in 1:n){
		inc<-which(data[,1]==1)
		y[,,i]<-data[inc,3:4]
		}

	
#another way but doesn't quite work
#	data<-t(data.frame(strsplit(lines,"\t")[6:length(lines)]))
#	rownames(data)<-seq(1:p)
#	colnames(data)<-c('frame','lm','x','y')
#	data<-as.matrix(data)
	
	d<-array2matrix(y)
	rownames(d)<-fn
	return(d)
	}
	
readmorphometrikafile<-function(fn=''){
	lines<-readLines(fn)
	lines.split1<-strsplit(lines,"\t")[1:2]
	n<-as.numeric(lines.split1[[1]][1])
	p<-as.numeric(lines.split1[[1]][2])
	f<-as.numeric(lines.split1[[1]][3])
	k<-as.numeric(lines.split1[[1]][4])
	colnames<-lines.split1[[2]][1]
	lines.split2<-(strsplit(lines,"\t")[3:length(lines)])
	data.num<-matrix(0,n,p*k)
	data.ch<-matrix('',n,f)
	for(i in 1:n){
		data.ch[i,1:f]<-lines.split2[[i]][1:f]
		data.num[i,1:(k*p)]<-as.numeric(lines.split2[[i]][(f+1):(f+k*p)])
		}
	data.frame<-data.frame(data.ch, data.num)
	data.array<-matrix2array(data.num)
	return(data.array)
	}

makeH<-function(theta){
	H<-matrix(0,2,2)
	H[1,1]<-cos(theta)
	H[1,2]<--sin(theta)
	H[2,1]<--H[1,2]
	H[2,2]<-H[1,1]
	H
	}

euclid<-function(p1,p2){		#euclidean distance between two points
	d<-0
	for(m in 1:length(p1)){
		d<-d+(p1[m]-p2[m])^2
		}
	euclid<-sqrt(d)
	}

twoDangle<-function(a,b){
	#a and b are vectors with start at 0,0 and end at [1]=x, [2]=y
	aa<-atan(a[2]/a[1])
	if(a[1]<0 & a[2]>0){
		aa<-pi+aa
	} else if (a[1]<0 & a[2]<0){
		aa<-pi+aa
	} else if (a[1]>0 & a[2]<0){
		aa<-2*pi+aa
	}

	ab<-atan(b[2]/b[1])
	if(b[1]<0 & b[2]>0){
		ab <-pi+ ab
	} else if(b[1]<0 & b[2]<0){
		ab <-pi+ ab
	} else if(b[1]>0 & b[2]<0){
		ab <-2*pi+ ab
	}
	
	twoDangle<-ab-aa
	if(twoDangle>=pi){twoDangle<-twoDangle-2*pi}
	twoDangle
	}
	
rfscale<-function(x,y){			#find the resistant fit scale factor
	t<-numeric(dim(y)[1]-1)
	tau<-numeric(dim(y)[1])
	for(j in 1:dim(y)[1]){
		l<-0
		for(k in 1:dim(y)[1]){
			if(j!=k){
				l<-l+1
				dx<-euclid(x[j,], x[k,])
				dy<-euclid(y[j,], y[k,])
				t[l]<-dx/dy
				}
			}
		tau[j]<-median(t)
		}
	rfscale<-1/median(tau)
	}
	
rftranslate<-function(x,y){				#find the resistant fit translation parameter
	t<-numeric(dim(y)[1])
	out<-numeric(dim(y)[2])
	for(k in 1:dim(y)[2]){
		for(j in 1:dim(y)[1]){
			t[j]<-y[j,k]-x[j,k]
			}
		out[k]<-median(t)
		}
	rftranslate<-out
	}

rfrotate<-function(x,y){				#find the resistant fit rotation parameter
	t1<-numeric(dim(y)[1]-1)
	t2<-numeric(dim(y)[1])
	xvec<-numeric(dim(y)[2])
	yvec<-numeric(dim(y)[2])
	H<-matrix(0,2,2)
	for(j in 1:dim(y)[1]){
		l<-0
		for(k in 1:dim(y)[1]){
			if(k!=j){
				l<-l+1
				for(m in 1:dim(y)[2]){
					xvec[m]<-x[k,m]-x[j,m]
					yvec[m]<-y[k,m]-y[j,m]
					}
				t1[l]<-twoDangle(xvec,yvec)
				}
			}
		t2[j]<-median(t1)
		}
	theta<-median(t2)
	H[1,1]<- cos(theta)
	H[1,2]<- -sin(theta)
	H[2,1]<- sin(theta)
	H[2,2]<-cos(theta)
	rfrotate<-H
	}

translate<-function(y,t){	#y is the row vector to translate by t
	for(j in 1:dim(y)[1]){
		y[j,]<-y[j,]-t
		}
	y
	}
	
mediansize<-function(y){		#finds the median size of a figure
	n<-dim(y)[1]
	p<-n*(n-1)/2
	t<-numeric(p)
	l<-0
	for(i in 1:(n-1)){
		for(j in (i+1):n){
			l<-l+1
			t[l]<-euclid(y[i,], y[j,])
			}
		}
	mediansize<-median(t)
	}
	
medianfigure<-function(y){
	ybar<-matrix(0,dim(y)[1], dim(y)[2])
	for(i in 1:dim(y)[1]){
		for(j in 1:dim(y)[2]){
			ybar[i,j]<-median(y[i,j,])
			}
		}
	ybar
	}
	

	
rf<-function(x,y){ 			#fits the figures in y to x
	yt<-array(0,dim=dim(y))
	for(i in 1:dim(y)[3]){ 		# number of figures in y
		yy<-y[,,i]
		yy<-yy/(rfscale(x,yy))
		yy<-yy%*%rfrotate(x,yy)
		#t<-rftranslate(x,yy)
		# yt<-apply(yy,1,function(x)(x-t)) # this seems to give the transpose of the correct result
		yy<-translate(yy, rftranslate(x,yy))
		yt[,,i]<-yy
		}
	yt
	}
	
getsize<-function(x,method='ls'){
	s<-numeric(dim(x)[3])
	if(method=='median'){
		for(i in 1:dim(x)[3]){
			s[i]<-mediansize(x[,,i])
			}
		}
	return(s)
	}

orf<-function(y){
	#create arrays
	yols<-array(0,dim=dim(y))
	x<-matrix(0,dim(y)[1], dim(y)[2])
	#the code
	yols<-procGPA(y)$rotated
	x<-medianfigure(yols)
	x<-x/mediansize(x)
	orf<-rf(x,yols)
	}
	
gorf<-function(y){
	convergence<-0.001
	#create arrays
	data<-array(0,dim=dim(y))
	yorf<-array(0,dim=dim(y))
	x<-matrix(0,dim(y)[1], dim(y)[2])
	xstar<-matrix(0,dim(y)[1], dim(y)[2])
	#the code
	# I need to write an OLS code because the shapes function procGPA rotated everything by
	#45 degrees or so. Since my guppies started at TPR alignment, I don't need the 
	#data<-procGPA(y)$rotated
	data<-y
	x<-medianfigure(data)
	x<-x/mediansize(x)
	done<-FALSE
	while(done==FALSE){
		data<-rf(x,data)
		xstar<-medianfigure(data)
		xstar<-xstar/mediansize(xstar)
		d<-abs(xstar-x)
		c<-median(c(d[,1], d[,2]))
		if(c<-convergence){
			done<-TRUE
		} else{
			x<-xstar
		}
		}
	return(data)
	}

shape.tpr<-function(x,lm1,lm2){
	#input is an array
	n<-dim(x)[3]
	p<-dim(x)[1]
	tpr<-x
	for(i in 1:n){
		xbxa<-(x[lm2,1,i] - x[lm1,1,i])
		xcxa<-(x[,1,i] - x[lm1,1,i])
		ybya<-(x[lm2,2,i] - x[lm1,2,i])
		ycya<-(x[,2,i] - x[lm1,2,i])
		tpr[,1,i]<-(xbxa*xcxa+ybya*ycya)/(xbxa^2+ybya^2)
		tpr[,2,i]<-(xbxa*ycya-ybya*xcxa)/(xbxa^2+ybya^2)
		}
	return(tpr)
	}
	
plot.difference.vectors<-function(ybar, d, mag=1, zoom=1,addzero=FALSE){ #addzero is my special function
	# to add a zero to the last column for the caudal fin y position
	#ybar is the mean figure, d is the difference vector
	p<-length(ybar)
	h<-ybar+0.5*d
	l<-ybar-0.5*d
	if(addzero==TRUE){
		p<-p+1
		h[p]<-0.0
		l[p]<-0.0
		}
	pdata<-matrix(0,2,p)
	pdata[1,]<-h
	pdata[2,]<-l
	pdata<-matrix2array(pdata)
	plotshapes.vectors(pdata[,,2], pdata[,,1],mag=mag,zoom=zoom) #grand mean low to high
	}
	
plotshapes.vectors<-function(x, y, mag=1, zoom=1){		#x is the base figure, y is the target
		#x and y are in the format of a figure matrix (the ,,ith element of a data array)
	d<-x+mag*(y-x)
	extra<-zoom*0.1
	hmin<-min(x[,1])-extra*(max(x[,1])-min(x[,1]))
	hmax<-max(x[,1])+extra*(max(x[,1])-min(x[,1]))
	vmin<-min(x[,2])-extra*(max(x[,2])-min(x[,2]))
	vmax<-max(x[,2])+extra*(max(x[,2])-min(x[,2]))
	plot(x, asp=1,xlim=c(hmin, hmax),ylim=c(vmin,vmax))
	for(i in 1:dim(x)[1]){
		arrows(x[i,1], x[i,2], d[i,1], d[i,2], length=0.1)
		}
	}
	
myplotshapes <- function(z){
	#x is an array as specified in the shapes package
	
	#vectorize x
	n <- dim(z)[3]
	p <- dim(z)[1]
	x <- numeric(n*p)
	y <- numeric(n*p)
	r <- 0
	for(i in 1:n){
		for(j in 1:p){
			r <- r+1
			x[r] <- z[j,1,i]
			y[r] <-	z[j,2,i]		
		}
	}
	plot(x,y)
}