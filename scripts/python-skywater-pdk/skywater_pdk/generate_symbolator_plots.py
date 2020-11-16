import sys
import symbolator
import argparse
from pathlib import Path
import errno
import contextlib
import traceback


@contextlib.contextmanager
def redirect_argv(args):
    sys._argv = sys.argv
    sys.argv = args
    yield
    sys.argv = sys._argv


def main(argv):
    parser = argparse.ArgumentParser(prog=argv[0])
    parser.add_argument(
        'libraries_dir',
        help='Path to the libraries directory of skywater-pdk',
        type=Path
    )
    parser.add_argument(
        'output_dir',
        help='Path to the output directory',
        type=Path
    )
    parser.add_argument(
        '--libname',
        help='Library name to generate the Symbolator diagrams for',
        type=str
    )
    parser.add_argument(
        '--version',
        help='Version for which the Symbolator diagrams should be generated',
        type=str
    )
    parser.add_argument(
        '--create-dirs',
        help='Create directories for output when not present',
        action='store_true'
    )
    parser.add_argument(
        '--failed-inputs',
        help='Path to files for which Symbolator failed to generate diagram',
        type=Path
    )

    args = parser.parse_args(argv[1:])

    libraries_dir = args.libraries_dir

    symbol_v_files = libraries_dir.rglob('*.symbol.v')

    nc = contextlib.nullcontext()

    with open(args.failed_inputs, 'w') if args.failed_inputs else nc as err:
        for symbol_v_file in symbol_v_files:
            if args.libname and args.libname != symbol_v_file.parts[1]:
                continue
            if args.version and args.version != symbol_v_file.parts[2]:
                continue

            print(f'===> {str(symbol_v_file)}')
            libname = symbol_v_file.parts[1]
            out_filename = (args.output_dir /
                            symbol_v_file.resolve()
                            .relative_to(libraries_dir.resolve()))
            out_filename = out_filename.with_suffix('.svg')
            out_dir = out_filename.parent

            if not out_dir.exists():
                if args.create_dirs:
                    out_dir.mkdir(parents=True)
                else:
                    print(f'The output directory {str(out_dir)} is missing')
                    print('Run the script with --create-dirs')
                    return errno.ENOENT

            if out_filename.exists():
                print(f'The {out_filename} already exists')
                return errno.EEXIST

            arguments = (f'--libname {libname} --title -t -o {out_filename}' +
                         f' --output-as-filename -i {str(symbol_v_file)}' +
                         ' --format svg')
            with redirect_argv(arguments.split(' ')):
                try:
                    symbolator.main()
                except Exception:
                    print(
                        f'Failed to run: symbolator {arguments}',
                        file=sys.stderr
                    )
                    print('Error message:\n', file=sys.stderr)
                    traceback.print_exc()
                    err.write(f'{symbol_v_file}\n')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
