f=filter;s[]=[[]];s(c:p)=do(l:c)<-[c];(l,p)<-[(l,p),(-l,c:p)];(l:)<$>s(f(/=0-l)<$>f(notElem l)p) 
