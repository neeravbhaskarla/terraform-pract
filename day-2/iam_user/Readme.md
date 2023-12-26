## Graph visulaization of the connected components
![dot](https://github.com/neeravbhaskarla/terraform-pract/assets/57148990/f1e78ddd-803f-4260-874d-2e91a3a7e29c)

#### graphviz
To visualize the dependencies of the instances or resources with other resources, with the help of dot we can generate a svg file, which visualizes the relational graph of the resources. 


###### Installation

```sh
brew install graphviz
```
After running this command graphviz will be installed 

1. Now we need to go the directory where our terraform scripts are present. 
2. Then we will run the following command
```sh
terraform graph > graph.dot
cat graph.dot | dot -Tsvg > graph.svg
```

This will generate a svg file of name graph.svg. 
