Support files for setting up the technology on Synospys Flow
Alpha quality, provided as-is, no guarantees.

```
git submodule update --init libraries/sky130_fd_sc_hd/latest
make sky130_fd_sc_hd
cd vendor/synopsys
make sky130_fd_sc_hd_db
make sky130_fd_sc_hd_mw
make sky130_fd_sc_hd_ndm
make tluplus
```
