function [seed] = vowelVal(name)

    tempVal = 0;
      %VowelVal Construct an instance of this class
        %   Change lowercase to uppercase and calculate Seed value
    upperName = upper(name);
    %disp(length(upperName))
    for i=1:length(upperName)
        if(upperName(i) == 'A')
            tempVal = tempVal + 16; 
        elseif(upperName(i) == 'E')
            tempVal = tempVal + 64;
        elseif(upperName(i) == 'I')
            tempVal = tempVal + 256;
        elseif(upperName(i) == 'O')
            tempVal = tempVal + 512;
        elseif(upperName(i) == 'U')
            tempVal = tempVal + 1024;
        end
    end
    seed = tempVal;
end