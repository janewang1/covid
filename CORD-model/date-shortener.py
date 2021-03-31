#put sha from excel into quotes and commas for json-readerCOPY

sha = []

outputFile = open('SHAs/finalCORD2020nov.txt', "w+")
count = 0
with open('SHAs/CORD2020nov.txt', 'r+') as file:
    for line in file:
        # if count == 5000:
        #     break

        # remove duplicate papers separated by ;
        if ';' not in line:
            line = line.replace('\n', "")
            line = '"' + line + '", '
            #print(line)
            sha.append(line)
            # outputFile.write(line)
            count+=1

# remove last comma
lastComma = sha[-1]
lastComma = lastComma[:-2]
# print(lastComma)
sha.pop()
sha.append(lastComma)

#write sha to file
for s in sha:
    outputFile.write(s)

outputFile.close()
file.close()
