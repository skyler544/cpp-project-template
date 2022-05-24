# https://stackoverflow.com/a/30602701

##################################################
################### Variables ####################
SRC_DIR  := src
OBJ_DIR  := obj
BIN_DIR  := bin

EXE      := $(BIN_DIR)/example
SRC      := $(wildcard $(SRC_DIR)/*.cpp)
OBJ      := $(SRC:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)

# variables for the executable and directory of
# test code
UNIT     := $(BIN_DIR)/unit
TEST_DIR := tests

# combine variables simply by separating them with a space
TESTS    := $(wildcard $(TEST_DIR)/*.cpp)
TESTS    := $(TESTS) $(SRC)
TESTS    := $(filter-out src/main.cpp, $(TESTS))
TEST_OBJ := $(TESTS:$(TEST_DIR)/%.cpp=$(OBJ_DIR)/%.o) $(OBJ)
TEST_OBJ := $(filter-out $(OBJ_DIR)/main.o, $(TEST_OBJ))
TEST_OBJ := $(filter-out $(SRC_DIR)/%.cpp, $(TEST_OBJ))

CPPFLAGS := -Iinclude -Ilib -MMD -MP # C PreProcessor flags
CXXFLAGS := -std=c++20 -Wall -Werror -pedantic-errors

# this is actually only used when linking static libraries, so
# it's no good for catch2
LDFLAGS  := -Llib
LDLIBS   :=

##################################################
###################### Build #####################
.PHONY: all clean unit

all: $(EXE)

# rule to link the main code and produce an executable
$(EXE): $(OBJ) | $(BIN_DIR)
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

unit: $(UNIT)

# separate rule to link the test code and
# produce an executable
$(UNIT): $(TEST_OBJ) | $(BIN_DIR)
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

# separate rule to compile the test code
$(OBJ_DIR)/%.o: $(TEST_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

clean:
	@$(RM) -rv $(BIN_DIR) $(OBJ_DIR)


# Use this to output the contents of variables
# when trying to figure out how a rule gets
# resolved
make-debug:
	@echo $(TEST_OBJ)

-include $(OBJ.o=.d)
