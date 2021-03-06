OMNI_INC = /usr/local/omniorb-4.2.1/include
TANGO_INC = /usr/local/tango-9.2.2/include/tango
ZEROMQ_INC = /usr/local/zeromq-4.0.7/include

LIBHDB_INC = libhdbpp/src

DBIMPL_INC = `mysql_config --include`
DBIMPL_LIB = `mysql_config --libs_r`


CXXFLAGS += -std=gnu++0x -Wall -DRELEASE='"$HeadURL: svn+ssh://scalamera@svn.code.sf.net/p/tango-cs/code/archiving/hdb++/libhdb++mysql/trunk/Makefile $ "' $(DBIMPL_INC) -I$(TANGO_INC) -I$(OMNI_INC) -I$(ZEROMQ_INC) -I$(LIBHDB_INC)
CXX = g++


##############################################
# support for shared libray versioning
#
LFLAGS_SONAME = $(DBIMPL_LIB) -Wl,-soname,
SHLDFLAGS = -shared
BASELIBNAME       =  libhdb++mysql
SHLIB_SUFFIX = so

#  release numbers for libraries
#
 LIBVERSION    = 5
 LIBRELEASE    = 0
 LIBSUBRELEASE = 0
#

LIBRARY       = $(BASELIBNAME).a
DT_SONAME     = $(BASELIBNAME).$(SHLIB_SUFFIX).$(LIBVERSION)
DT_SHLIB      = $(BASELIBNAME).$(SHLIB_SUFFIX).$(LIBVERSION).$(LIBRELEASE).$(LIBSUBRELEASE)
SHLIB         = $(BASELIBNAME).$(SHLIB_SUFFIX)



.PHONY : install clean

lib/LibHdb++MySQL: lib obj obj/LibHdb++MySQL.o
	$(CXX) obj/LibHdb++MySQL.o $(SHLDFLAGS) $(LFLAGS_SONAME)$(DT_SONAME) -o lib/$(DT_SHLIB)
	ln -sf $(DT_SHLIB) lib/$(SHLIB)
	ln -sf $(SHLIB) lib/$(DT_SONAME)
	ar rcs lib/$(LIBRARY) obj/LibHdb++MySQL.o

obj/LibHdb++MySQL.o: src/LibHdb++MySQL.cpp src/LibHdb++MySQL.h $(LIBHDB_INC)/LibHdb++.h
	$(CXX) $(CXXFLAGS) -fPIC -c src/LibHdb++MySQL.cpp -o $@

clean:
	rm -f obj/*.o lib/*.so* lib/*.a

lib obj:
	@mkdir $@
	
	
