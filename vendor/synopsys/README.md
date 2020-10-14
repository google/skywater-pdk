Support files for setting up the technology on Synospys Flow
Alpha quality, provided as-is, no guarantees.

```
git checkout 4e5e318e0cc578090e1ae7d6f2cb1ec99f363120
git submodule update --init libraries/sky130_fd_sc_hd/latest
make sky130_fd_sc_hd
cd vendor/synopsys
make sky130_fd_sc_hd_db
make sky130_fd_sc_hd_mw
make sky130_fd_sc_hd_ndm
make tluplus
```
