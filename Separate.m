function [Im1,Im2]=Separate(data,bb)
Im1=zeros(size(data)); 
b=ceil(bb);
 x=[b(1):b(1)+b(3)];
                    
            y=[b(2):b(2)+b(4)];
        
            for(x1=x(1):x(length(x)))
                for(y1=y(1):y(length(y)))
                    try
                    Im1(y1,x1,1)=data(y1,x1,1);
                    Im1(y1,x1,2)=data(y1,x1,2);
                    Im1(y1,x1,3)=data(y1,x1,3);
                    Im2(y1-b(2)+1,x1-b(1)+1,1)=Im1(y1,x1,1);
                    Im2(y1-b(2)+1,x1-b(1)+1,2)=Im1(y1,x1,2);
                    Im2(y1-b(2)+1,x1-b(1)+1,3)=Im1(y1,x1,3);
                    catch CE
                    end
                end
            end
        
 %imshow(uint8(Im1));
 Im1=uint8(Im1);
 Im2=uint8(Im2);