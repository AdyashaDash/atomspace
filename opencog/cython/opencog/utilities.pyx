from opencog.atomspace cimport AtomSpace
from opencog.type_constructors import set_type_ctor_atomspace

cdef extern from "../PythonEval.h" namespace "opencog::PythonEval":
    char* pyObjectToCString(object)

# Avoid recursive intialization
is_initialized = False

def initialize_opencog(AtomSpace atomspace, object config = None):

    # Avoid recursive intialization
    global is_initialized
    if (is_initialized):
        return
    is_initialized = True

    cdef char *configFileString
    if (config == None):
        configFileString = NULL
    else:
        configFileString = pyObjectToCString(config)
    c_initialize_opencog(atomspace.atomspace, configFileString)
    set_type_ctor_atomspace(atomspace)

def finalize_opencog():
    c_finalize_opencog()
    set_type_ctor_atomspace(None)

def configuration_load(object config):
    cdef char *configFileString = pyObjectToCString(config)
    c_configuration_load(configFileString)
