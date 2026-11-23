#ifndef DIGRAPH_T
#define DIGRAPH_T


#include<iostream>
using std::cin;
using std::cout;
using std::cerr;
using std::endl;
using std::ws;
using std::ios;
using std::ostream;


#include<fstream>
using std::ifstream;

#include<string>
using std::string;

#include<cctype>



#include<list>
#include<vector>
#include<queue>
#include<stack>
#include<conio.h>							//for getche()







/////////////////////////////////// Digraph ///////////////////////////////////
//
// function name      : Digraph
//
// purpose            : constructor
//
// input parameters   : none
//
// output parameters  : none
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
Digraph<V, W>::Digraph()
{
	num_of_verticies = 0;		// Initialize num_of_verticies to 0
}



/////////////////////////////////// ~Digraph //////////////////////////////////
//
// function name      : ~Digraph
//
// purpose            : destructor
//
// input parameters   : none
//
// output parameters  : none
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
Digraph<V, W>:: ~Digraph()
{
	// Clear the "graph_array" vector 
	graph_array.clear();
	// Reset num_of_verticies to 0
	num_of_verticies = 0;
}



/////////////////////////////////// set_size //////////////////////////////////
//
// function name      : set_size
//
// purpose            : determines the  number of lines in the input file; 
//						ie the number of verticies in the graph
//
// input parameters   : none
//
// output parameters  : one called inFile
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
void Digraph<V, W>::set_size(ifstream& inFile)
{
	
	// check to see if file is successfully found and open
	if (!inFile.is_open()) {
		cout << "\nError! Cannot open file. Please try the program again.\n";
		return;
	}
	else
	{
		cout << "Successfully opened file.\n\n";
	}

	// reset "num_of_vertices"
	num_of_verticies = 0;

	// checking for each line in the text file (if successfully open)
	string line;
	while (std::getline(inFile, line)) 
	{
			num_of_verticies++;		// increase "num_of_verticies" by 1 per line
	}

	// reset file stream for getDigraph() later by moving its pointer back
		// to the very start (top left) of the file
	inFile.clear();
	inFile.seekg(0, ios::beg);
}



/////////////////////////////////// get_size //////////////////////////////////
//
// function name      : get_size
//
// purpose            : gets the size of the "array" which holds the verticies 
//						of the graph
//
// input parameters   : none
//
// output parameters  : none
//
// return value       : num_of_verticies of type int
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
int  Digraph<V, W>::get_size()
{
	return num_of_verticies;
}


/////////////////////////////////// getDigraph ////////////////////////////////
//
// function name      : getDigraph
//
// purpose            : retrives the input file info and stores it as a vector. 
//						The graph is stored implicitly in file
//
// input parameters   : none
//
// output parameters  : one called inFile
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
void Digraph<V, W>::getDigraph(ifstream& inFile)
{

	vertex<V, W>  v;
	edge_representation<V, W> e;
	std::list< edge_representation<V, W> > edgeList;
	std::vector<vertex<V, W> > graph;

	// for the # of verticies (# of lines in .txt file), loop:
	for (int i = 0; i < num_of_verticies; i++) 
	{
		// initialize current line by clearing previous "edgeList" vector and taking 
			// the first word (string, _ for spaces) and storing it as "name" of "v"
		edgeList.clear();
		inFile >> v.name;
		inFile >> ws;
		
		// while the next entry in "inFile" is not '#' (line is not ended yet), loop:
		while (inFile.peek() != '#') 
		{
			// take in the edge's name and weight, and push it into the "edgeList" list
				// also skip the subsequent empty space (ws)
			inFile >> e.name >> e.weight;
			edgeList.push_back(e);
			inFile >> ws;
		}

		// once the while loop above ends, the last thing not traversed over in the
			// current line is the hashtag (#), so get rid of it
		char junkChar;
		inFile >> junkChar;

		// set the "edgeList" of "v" to the final "edgeList" found from this line, and
			// push it into the "graph" vector
		v.edgeList = edgeList;
		graph.push_back(v);

	}

	// set the Digraph's "graph_array" vector to the final "graph" vector found above
	graph_array = graph;

	// close the file for organization purposes (no longer needed from here)
	inFile.close();
}




/////////////////////////////////// isVertex //////////////////////////////////
//
// function name      : isVertex
//
// purpose            : determines whether input is a vertex in the graph. 
//						Returns the index/location if in;otherwise returns -666
//
// input parameters   : none
//
// output parameters  : one of type V, called v
//
// return value       : an int
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
int Digraph<V, W>::isVertex(V& v)
{

	// looping through each index in the vertex array (graph_array), check to see
		// if index [i] of the array is the desired vertex being searched for,
		// and if so then return that index number.
	for (int i = 0; i < num_of_verticies; i++)
	{
		if (graph_array[i].name == v)
		{
			return i;
		}
	}

	// else, if entire vertex array has been searched already and "v" was not found:
	return -666;
}





/////////////////////////////////// isUniEdge /////////////////////////////////
//
// function name      : isUniEdge 
//
// purpose            : determines if the edge from v1 to v2 is an edge in the 
//						graph. Returns the location or index of the first vertex 
//						v1 if the edge is present in the graph; 
//						otherwise returns -666
//
// input parameters   : none
//
// output parameters  : two of type V, called v1 and v2
//
// return value       : an int - the index/location of the start vertex if 
//						it's present in the graph; otherwise -666
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
int Digraph<V, W>::isUniEdge(V& v1, V& v2)
{

	// first check to see if both vectors are actually in the graph or not
	if (isVertex(v1) == -666 || isVertex(v2) == -666) {
		return -666;
	}
	
	// initialize a variable to hold the index location of vertex 1 (v1)
	int indexOfv1 = isVertex(v1);

	// create a temporary queue to hold all the names (V) of adjacent vertices to v1
	std::queue<V> vertexNameQueue;

	// for every edge adjacent to v1 (graph_array[indexOfv1]), push its name to the queue
	for (edge_representation<V, W> adjacentEdge : graph_array[indexOfv1].edgeList) 
	{
		vertexNameQueue.push(adjacentEdge.name);
	}

	// loop through the queue checking to see if one of the adjacent vertex names matches v2
	while (!vertexNameQueue.empty()) 
	{
		if (vertexNameQueue.front() == v2) 
		{
			return indexOfv1;
		}
		else
		{
			vertexNameQueue.pop();
		}
	}

	// if loop above doesn't return, then "v2" is not an adjacent vertex of v1, thus return -666:
	return -666;
}





/////////////////////////////////// isBiDirEdge ///////////////////////////////
//
// function name      : isBiDirEdge
//
// purpose            : determines if there is an edge from v1 to v2 and 
//						from v2 to v1 in the graph. Returns the location
//                      or index of the first vertex v1 if the edge is present 
//						in the graph; otherwise returns -666
//
// input parameters   : none
//
// output parameters  : two of type V, called v1 and v2
//
// return value       : an int - the index/location of the start vertex if it's 
//						present in the graph; otherwise -666
//
///////////////////////////////////////////////////////////////////////////////




template< typename V, typename W >
int Digraph<V, W>::isBiDirEdge(V& v1, V& v2)
{
	// below is a copy of the "isUniEdge" function definition, modified to also check
		// if v2 directs back to v1 as well

	// first check to see if both vectors are actually in the graph or not
	if (isVertex(v1) == -666 || isVertex(v2) == -666) {
		return -666;
	}

	// initialize a variable to hold the index location of vertex 1 (v1)
	int indexOfv1 = isVertex(v1);

	// create a temporary queue to hold all the names (V) of adjacent vertices to v1
		// and later for v2
	std::queue<V> vertexNameQueue;

	// for every edge adjacent to v1 (graph_array[indexOfv1]), push its name to the queue
	for (edge_representation<V, W> adjacentEdge : graph_array[indexOfv1].edgeList)
	{
		vertexNameQueue.push(adjacentEdge.name);
	}

	// NEW: initialize a bool var. for if there is an edge from v1 to v2
	bool v1_to_v2 = false;

	// loop through the queue checking to see if one of the adjacent vertex names matches v2
	while (!vertexNameQueue.empty())
	{

		// NEW: if v2 is adjacent from v1, then "v1_to_v2" = true and break out of loop early
		if (vertexNameQueue.front() == v2)
		{
			v1_to_v2 = true;
			break;
		}

		else
		{
			vertexNameQueue.pop();
		}
	}

	// NEW: if v2 is an adjacent vertex from v1, then check if v2 directs back to v1 also
	if (v1_to_v2) 
	{

		// start by clearing whatever left's in the queue
		while (!vertexNameQueue.empty())
		{
			vertexNameQueue.pop();
		}

		// initialize a variable to hold the index location of vertex 2 (v2)
		int indexOfv2 = isVertex(v2);

		// for every edge adjacent to v2, push its name into the queue
		for (edge_representation<V, W> adjacentEdge : graph_array[indexOfv2].edgeList)
		{
			vertexNameQueue.push(adjacentEdge.name);
		}

		// loop through the queue checking to see if one of the adjacent vertex names matches v2
		while (!vertexNameQueue.empty())
		{
			// if v1 is adjacent back from v2, then return index of v1
			if (vertexNameQueue.front() == v1)
			{
				return indexOfv1;
			}
			else
			{
				vertexNameQueue.pop();
			}
		}
		
	}


	// if loop above doesn't return, then "v2" is either not an adjacent vertex of v1, or 
		// v2 is an adjacent vertex of v1 but v2 isn't directed back at v1, thus return -666:
	return -666;
}





/////////////////////////////////// addVertex /////////////////////////////////
//
// function name      : addVertex
//
// purpose            : adds a vertex to the graph if it's not there
//
// input parameters   : none
//
// output parameters  : one of type V, called v
//
// return value       : an int; the location/index of the vertex if added; 
//						otherwise -666
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
int Digraph<V, W>::addVertex(V& v)
{

	// first, check if the inputted vertex is already in the graph (isVertex() function
		// returns -666 if it isn't (what we want), so if it returns anything else, then
		// this return -666 (vertex cannot be added since it already exists in graph)
	if (isVertex(v) != -666)
	{
		return -666;
	}

	// create a new temporary vertex object and set its "name" variable to input "v"
	vertex<V, W> newVertex;
	newVertex.name = v;

	// push it to the back of the graph's vector array, and increment num_of_verticies
	graph_array.push_back(newVertex);
	num_of_verticies++;

	// because the new vertex is always added to the end of the graph's array, the
		// "num_of_verticies" will always be its index in the array + 1, but to
		// satistify the "driverFunctions.cpp" definition, this has to return
		// 1 more than num_of_verticies:
	return (num_of_verticies + 1); 
}





/////////////////////////////////// deleteVertex //////////////////////////////
//
// function name      : deleteVertex
//
// purpose            : if a vertex is present in the graph, deletes it
//
// input parameters   : none
//
// output parameters  : one of type V
//
// return value       : a bool; true if added, false if not
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
bool Digraph<V, W>::deleteVertex(V& v)
{

	// create a temporary holder variable for the index of "v" in the graph's array
	int vertexIndex = isVertex(v);

	// if isVertex(v) returns -666, then "v" is not a vertex in the graph
	if (vertexIndex == -666)
	{
		return false;
	}

	// otherwise, vertex with name "v" was found in the graph's vertex array, so:
	else
	{

		// looping through each vertex in the graph (with a nested loop inside):
			// (currVertex is pass-by-reference as we will be mutating it inside)
		for (vertex<V, W> & currVertex : graph_array)
		{
			
			// intiialize a temporary list of edges 
			std::list< edge_representation<V, W> > newEdgeList;
			
			// (nested) looping thru each edge in the current vertex's edge list:
			for (edge_representation<V, W> currEdge : currVertex.edgeList)
			{
				// if the current edge's name isn't the one being removed, push
					// it into the new, temporary list
				if (currEdge.name != v)
				{
					newEdgeList.push_back(currEdge);
				}

			}

			// once nested loop ends, assign the new edge list, without any 
				// instances of the vertex being removed, to replace the 
				// current vertex's current edge list
			currVertex.edgeList = newEdgeList;
		}
		
		// once all instances of the vertex has been removed from every other
			// vertex's edge list, remove the actual vertex itself from the
			// graph's vector, decrement "num_of_verticies", and return "true"
		graph_array.erase(graph_array.begin() + vertexIndex);
		num_of_verticies--;
		return true;
	}
}





/////////////////////////////////// addUniEdge ////////////////////////////////
//
// function name      : addUniEdge
//
// purpose            : adds a uni-directional edge to the graph. If both 
//						edges present,inquires if the weight should be updated 
//						or not. Returns the location/index of the vertex at the 
//						end of the edge
//
// input parameters   : none
//
// output parameters  : two of type V 
//
// return value       : int; the location of the end of the edge
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
int Digraph<V, W>::addUniEdge(V& v1, V& v2, W& w)
{

	// if "isUniEdge" for v1 & v2 returns anything other than -666, then an edge
		// already exists between them
	if (isUniEdge(v1, v2) != -666)
	{
		return -666;
	}

	// if either "v1" or "v2" don't already exist in the graph (isVertex returns -666),
		// then use "addVertex()" to add the missing vertex/vertices
	if (isVertex(v1) == -666)
	{
		addVertex(v1);
	}
	if (isVertex(v2) == -666)
	{
		addVertex(v2);
	}

	// create the new edge object and assign it the name and weight inputted in parameter
	edge_representation<V, W> newEdge;
	newEdge.name = v2;
	newEdge.weight = w;

	// find the index of vertex "v1" in the graph array using "isVertex()", then push
		// the new edge into its edgeList
	graph_array[isVertex(v1)].edgeList.push_back(newEdge);

	// return the index of vertex "v2" in the graph array
	return isVertex(v2);
}






/////////////////////////////////// addBiDirEdge //////////////////////////////
//
// function name      : addBiDirEdge
//
// purpose            : adds a bi-directional edge to the graph
//
// input parameters   : none
//
// output parameters  : three; two of type V called v1 and v2 with one of 
//						type W called w
//
// return value       : an int; the location/index of the "end" of the edge, 
//						namely v2.
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
int Digraph<V, W>::addBiDirEdge(V& v1, V& v2, W& w)
{

	// first, check if there already exists a bi-directional edge between vertices
		// "v1" & "v2" in the graph, and if yes, return -666
	if (isBiDirEdge(v1, v2) != -666)
	{
		return -666;
	}

	// if either "v1" or "v2" don't already exist in the graph (isVertex returns -666),
	// then use "addVertex()" to add the missing vertex/vertices
	if (isVertex(v1) == -666)
	{
		addVertex(v1);
	}
	if (isVertex(v2) == -666)
	{
		addVertex(v2);
	}

	// checks if an edge already exists between the vertices (in each direction, individually)
		// and if there isn't (isUniEdge returns -666), then add an edge in that respective
		// direction with the parameterized weight
	if (isUniEdge(v1, v2) == -666)
	{
		addUniEdge(v1, v2, w);
	}
	if (isUniEdge(v2, v1) == -666)
	{
		addUniEdge(v2, v1, w);
	}

	// return the index of vertex "v2" in the graph array
	return isVertex(v2);
}





/////////////////////////////////// deleteUniEdge /////////////////////////////
//
// function name      : deleteUniEdge
//
// purpose            : deletes a uni-directional edge from the graph
//
// input parameters   : none
//
// output parameters  : three; two of type V( for the edges ) and one of 
//						type W for the weight
//
// return value       : a bool; true if successful delete, otherwise false
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
bool Digraph<V, W>::deleteUniEdge(V& v1, V& v2, W& w)
{

	// first, check if the SINGLE-directional edge already exists in the graph
	if (isUniEdge(v1, v2) == -666)
	{
		return false;
	}

	// else, if edge doesn't exist already in graph, then find the index of vertex
		// "v1" in the graph's vertex array and create a temporary edge list
	int indexOfv1 = isVertex(v1);
	std::list< edge_representation<V, W> > newEdgeList;
	
	// with the edge list of vertex "v1", loop through all of the edges:
	for (edge_representation<V, W> currEdge : graph_array[indexOfv1].edgeList)
	{
		// if the current edge is NOT directed to vertex "v2", push it into the temp edge list
		if (currEdge.name != v2)
		{
			newEdgeList.push_back(currEdge);
		}
	}
	
	// assign the new edge list (w/o any instances to "v2") to v1's edge list & return "true"
	graph_array[indexOfv1].edgeList = newEdgeList;
	return true;
}





/////////////////////////////////// deleteBiDirEdge ///////////////////////////
//
// function name      : deleteBiDirEdge
//
// purpose            : deletes a bi-directional edge grom the graph
//
// input parameters   : none
//
// output parameters  : three; two of type V( for the edges ) and one of 
//						type W for the weight
//
// return value       : a bool; true if successful delete, otherwise false
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
bool Digraph<V, W>::deleteBiDirEdge(V& v1, V& v2, W& w)
{

	// first, check if the BI-directional edge already exists in the graph (false if yes)
	if (isBiDirEdge(v1, v2) == -666)
	{
		return false;
	}

	// if the function makes it here (past the edge-case check above), then it can
		// be assumed that an edge exists in BOTH directions between v1 and v2,
		// so using "deleteUniEdge" in both directions will do the trick
	deleteUniEdge(v1, v2, w);
	deleteUniEdge(v2, v1, w);
	
	return true;
}





/////////////////////////////////// printDigraph //////////////////////////////
//
// function name      : printDigraph
//
// purpose            : prints the graph
//
// input parameters   : none
//
// output parameters  : none
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
void Digraph<V, W>::printDigraph()
{


	typename std::list< edge_representation<V, W> >::iterator  it;


	for (int j = 0; j < num_of_verticies; j++)
	{
		cout << " \nfor the vertex " << graph_array[j].name << " we have the following edges : \n";

		for (it = graph_array[j].edgeList.begin(); it != graph_array[j].edgeList.end(); it++)
		{
			cout << " < " << graph_array[j].name << ", " << (*it).name << ", " << (*it).weight << " > " << endl;
		}

		cout << endl << " press enter to continue viewing the graph " << endl;
		_getche();
	}


	cout << endl << endl;
}





/////////////////////////////////// breadth ///////////////////////////////////
//
// function name      : breadth
//
// purpose            : performs a breadth first traversal of the graph starting 
//						at any user entered vertex
//
// input parameters   : one of type V
//
// output parameters  : none
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
void Digraph<V, W>::breadth(V& start_vertex)
{

	// start by initializing an int var. to hold the starting vertex's index in the
		// graph's vertex array, and check if it's valid (-666 = invalid)
	int startingIndex = isVertex(start_vertex);
	if (startingIndex == -666)
	{
		cout << "\nVector is not in the graph!!!\n\n";
		return;
	}

	// initialize a vector-array for "has this vertex already been visited?" and start it
		// off by pushing "false" into it for as many times as there are vertices in the
		// graph, such that the indices in it map to the indices in the graph's vertex array, 
	std::vector<bool> visited;
	for (int i = 0; i < num_of_verticies; i++)
	{
		visited.push_back(false);
	}
	
	// initialize a queue to hold the vertices (for BFT) & add the starting vertex to it
	std::queue< vertex<V, W> > vertexQueue;
	vertexQueue.push(graph_array[startingIndex]);
	visited[startingIndex] = true;	// also set the starting vertex to "visited"

	cout << "Breadth First Traversal of graph:";
	int counter = 1;	// for output formatting

	while (!vertexQueue.empty())
	{

		// formatting shenanigans to make the traversal printing look nice and beautifulll
			// (seeing how many digits are in the counter for the current iteration of
			// the loop, and subtracting that many from 5 spaces during output)
		int numSpaces = 5;
		int tempNum = counter;
		while (tempNum > 0)
		{
			numSpaces--;
			tempNum /= 10;
		}
		cout << "\n     " << counter << ")";
		for (int i = 0; i < numSpaces; i++)
		{
			cout << " ";
		}

		// find the current vertex's index in graph_array using "isVertex()", print the
			// vertex's name, and then pop it from the queue
		int currIndex = isVertex(vertexQueue.front().name);
		cout << graph_array[currIndex].name;
		vertexQueue.pop();

		// for each edge from this current vertex:
		for (edge_representation<V, W> currEdge  : graph_array[currIndex].edgeList)
		{

			// find the index in graph_array of the vertex on the other end w/ "isVertex()"
			int currEdgeIndex = isVertex(currEdge.name);

			// if the corresponding index in the "visited" array == false:
			if ( (currEdgeIndex != -666) && (visited[currEdgeIndex] == false) )
			{

				// then add that vertex on the other end of this current edge to
					// the vertex queue, and set it to "visited" (in visited[i] array)
				vertexQueue.push(graph_array[currEdgeIndex]);
				visited[currEdgeIndex] = true;

			}

		}

		// output formatting stuff
		counter++;
	}

	cout << "\n\n";

}//end function






/////////////////////////////////// depth /////////////////////////////////////
//
// function name      : depth
//
// purpose            : performs a depth first traversal of the graph starting 
//						at any user entered vertex
//
// input parameters   : one of type V
//
// output parameters  : none
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
void Digraph<V, W>::depth(V& start_vertex)
{

	// start by initializing an int var. to hold the starting vertex's index in the
		// graph's vertex array, and check if it's valid (-666 = invalid)
	int startingIndex = isVertex(start_vertex);
	if (startingIndex == -666)
	{
		cout << "\nVector is not in the graph!!\n\n";
		return;
	}

	// initialize a vector-array for "has this vertex already been visited?"
	std::vector<bool> visited;
	for (int i = 0; i < num_of_verticies; i++)
	{
		visited.push_back(false);
	}

	// initialize a STACK to hold the vertices (for DFT) & add the starting vertex to it
	std::stack< vertex<V, W> > vertexStack;
	vertexStack.push(graph_array[startingIndex]);

	cout << "Depth First Traversal of graph:";
	int counter = 1;	// for output formatting

	// while stack is NOT empty:
	while (!vertexStack.empty())
	{

		// create a temporary vertex variable for the current top of stack, then pop
			// it from the stack
		vertex<V, W> currVertex = vertexStack.top();
		vertexStack.pop();

		// set an int placeholder var. for the index of current vertex in graph's V-array
		int currIndex = isVertex(currVertex.name);

		// if the vertex was found in graph (!= -666) and NOT visited yet,
		if ( (currIndex != -666) && (visited[currIndex] == false) )
		{

			// formatting shenanigans [
			int numSpaces = 5;
			int tempNum = counter;
			while (tempNum > 0)
			{
				numSpaces--;
				tempNum /= 10;
			}
			cout << "\n     " << counter << ")";
			for (int i = 0; i < numSpaces; i++)
			{
				cout << " ";
			}
			// ]

			cout << graph_array[currIndex].name;
			counter++;

			// set current vertex to "visited"
			visited[currIndex] = true;

			// for every edge in the current vertex's edgeList:
			for (edge_representation<V, W> currEdge : graph_array[currIndex].edgeList)
			{

				// get the index, of the vertex on the other end of the edge, in the
					// graph's vertex array
				int currEdgeIndex = isVertex(currEdge.name);

				// if current edge's v2 is valid (!= -666) and has NOT been visited yet,
					// then push it into the stack
				if ( (currEdgeIndex != -666) && (visited[currEdgeIndex] == false) )
				{
					vertexStack.push(graph_array[currEdgeIndex]);
				}

			}

		}

	}

	cout << "\n\n";
}//end function




/////////////////////////////////// getOneVertex //////////////////////////////
//
// function name      : getOneVertex
//
// purpose            : queries user for an input vertex
//
// input parameters   : none
//
// output parameters  : one of type V, called v1
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
void Digraph<V, W>::getOneVertex(V& v1)
{
	cout << " Please enter a vertex name  : ";
	cin >> v1;
}



/////////////////////////////////// getTwoVerticies ///////////////////////////
//
// function name      : getTwoVerticies
//
// purpose            : queries user for two input verticies
//
// input parameters   : none
//
// output parameters  : two of type V, called v1 and v2
//
// return value       : none
//
///////////////////////////////////////////////////////////////////////////////



template< typename V, typename W >
void Digraph<V, W>::getTwoVerticies(V& v1, V& v2)
{
	// formatting output messages to as shown from above in the "getOneVertex" func.
	cout << " Please enter the FIRST vertex name  : ";
	cin >> v1;
	cout << " Please enter the SECOND vertex name  : ";
	cin >> v2;
}



///////////////////////////////////////////////////////////////////////////////


#endif
