# https://stackoverflow.com/a/30602701

##################################################
################### Variables ####################
SRC_DIR := src
TST_DIR := tests
OBJ_DIR := obj
BIN_DIR := bin

EXE      := $(BIN_DIR)/example
UNIT     := $(BIN_DIR)/unit
SRC      := $(wildcard $(SRC_DIR)/*.cpp)
TESTS    := $(wildcard $(TEST_DIR)/*.cpp)
OBJ      := $(SRC  :$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)
TEST_OBJ := $(TESTS:$(TEST_DIR)/%.cpp=$(OBJ_DIR)/%.o)

CPPFLAGS := -Iinclude -Ilib -MMD -MP # C PreProcessor flags
CXXFLAGS := -std=c++20 -Wall -Werror -pedantic-errors
LDFLAGS := -Llib
LDLIBS :=

##################################################
###################### Build #####################
.PHONY: all clean unit

all: $(EXE)

$(EXE): $(OBJ) | $(BIN_DIR)
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

unit: $(UNIT)

$(UNIT): $(TEST_OBJ) | $(BIN_DIR)
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(TEST_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

clean:
	@$(RM) -rv $(BIN_DIR) $(OBJ_DIR)

-include $(OBJ.o=.d)
