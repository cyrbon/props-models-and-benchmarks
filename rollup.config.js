import purs from "rollup-plugin-purs";
import copy from "rollup-plugin-copy";

export default {
  entry: "src/Main.purs",
  dest: "build/bundle.js",
  format: "cjs",
  sourceMap: true,
  plugins: [
    purs({
      optimizations: {
        uncurry: true,         // Whether to apply the uncurrying optimization or not
        inline: true,          // Whether to inline some functions or not
        removeDeadCode: true,  // Whether to remove dead code or not

	/* As of version `1.0.38` this optimization does not work correctly and
	 * removes all mutations inside the ST monad. This breaks libraries like
	 * `benchmark` or `maps` that rely on the ST monad.
	*/
        assumePureVars: false // Whether to assume that variable assignment is always pure
      }
    }),
    copy({
      "src/index.html": "build/index.html"
    })
  ]
};
