Synopsys support files
=======================

Support files for setting up the technology on Synospys Flow
Alpha quality, provided as-is, no guarantees.

```bash
# To build skywater-PDK
git submodule update --init libraries/sky130_fd_sc_hd/latest
make sky130_fd_sc_hd

# To generate synopsys libraries
cd vendor/synopsys
make sky130_fd_sc_hd

# Replace sc_hd with [sc_hdll, sc_hs, sc_ls or sc_ms] to compile other SC variants
```

Directory structure
--------------------

```pre
skywater-PDK
└── vendor/
    └── synopsys/
        ├── Makefile
        ├── scripts     : Common script to gnerated SNPS libraries
        ├── work        : Work directory while creating libraries
        ├── logs        : Stored logs
        └── PlaceRoute/
            └── common          : Common files
            └── $SC_LIB_NAME/
                ├── -NDM        : Final NDM to use with SNPS flow
                ├── -db_nldm    : Compiled DB files
                ├── -lib        : Fixed lib files
                ├── -techfile   : .tf and supported files
                ├── -lef        : Modified/Regenerated LEF Files
                ├── -gds        : Symbolic link of gds files
                ├── -verilog    : Fixed verilog, if required
                └── -others     : reserved
```

**Note**:
In `PlaceRoute/common` directory contains following 3 pre compiled files.

```pre
- sky130_fd_sc_hd.antenna.clf
- skywater130.mw2itf.map
- skywater130.mw.map
```
