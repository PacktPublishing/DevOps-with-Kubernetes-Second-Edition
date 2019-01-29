package controller

import (
	"github.com/devops.kubernetes.com/devops-operator/pkg/controller/book"
)

func init() {
	// AddToManagerFuncs is a list of functions to create controllers and add them to a manager.
	AddToManagerFuncs = append(AddToManagerFuncs, book.Add)
}
