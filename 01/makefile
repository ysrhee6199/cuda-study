# Compiler
NVCC = nvcc

# Target file
TARGET = a

# CUDA architecture flags
ARCH = -gencode arch=compute_86,code=sm_86

# Default source file (if not provided)
SRC ?= hello-pararllel.cu

# Default build mode
BUILD_MODE ?= debug

# Compiler flags for debug and release modes
DEBUG_FLAGS = -g -G -DDDEBUG
RELEASE_FLAGS = -O3 -DNDEBUG

# Select flags based on build mode
ifeq ($(BUILD_MODE), debug)
    CFLAGS = $(DEBUG_FLAGS)
else ifeq ($(BUILD_MODE), release)
    CFLAGS = $(RELEASE_FLAGS)
else
    $(error Unknown build mode: $(BUILD_MODE). Use 'debug' or 'release')
endif

# Build rules
all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) $(ARCH) $(CFLAGS) -o $(TARGET) $(SRC)

# Force rebuild if the source file changes
.PHONY: clean all

clean:
	rm -f $(TARGET)
