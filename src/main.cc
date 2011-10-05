#include <iostream>

#include "classA.hh"
#include "classB.hh"

using namespace std;

int main(int argc, char *argv[])
{
  cout << "Hello World !!!" << endl;
  classA *ptrA;
  classB *ptrB;
  int apa;
  ptrA = new classA();
  apa = ptrA->greet();
  ptrB = new classB();
  apa = ptrB->greet();
  return 0;
}
