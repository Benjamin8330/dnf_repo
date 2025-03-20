cat file_list | grep baseos > baseos1
   awk '{print $1}' baseos1 > baseos2
   while IFS= read -r file; do   rm -rf Packages/"$file"-[0-9]*-*.rpm; done < baseos2
   createrepo .
   
 