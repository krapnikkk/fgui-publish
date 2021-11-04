import typescript from 'rollup-plugin-typescript2';
// import resolve from '@rollup/plugin-node-resolve';
// import commonjs from 'rollup-plugin-commonjs';
export default [
    {
        input: './src/index.ts',
        output: [{
            format: 'cjs',
            file: './dist/index.js'
        }],
        // onwarn: function (warning) {
        //     if (warning.code === 'THIS_IS_UNDEFINED') {
        //         return;
        //     }
        //     console.error(warning.message);
        // },
        plugins: [
            typescript({
                tsconfigOverride: {
                    compilerOptions: {
                        declaration: false,
                        declarationMap: false,
                        module: "esnext"
                    }
                }
            }),
            // commonjs(),
            // resolve()
        ]
    }
]