"use strict";

exports.inputClass = function(){
  throw new Error("inputClass is not implemented");
};

exports.convertInputProps = function(unionDict1){
  return function(iconPositionDict){
    return function(labelPositionDict){
      return function(props){

	var propsConverted = {};
	if(props.iconPosition !== undefined){
	  propsConverted.iconPosition =
	    iconPositionDict.fromLeftOrRight(props.iconPosition);
	}
	if(props.labelPosition !== undefined){
	  propsConverted.labelPosition =
	    labelPositionDict.fromLeftOrRightOrLeftCornerOrRightCorner(
		props.labelPosition);
	}

	// If none of the props needed to be converted, then we return original
	// props.
	if(Object.keys(propsConverted).length == 0) return props;
	// Otherwise we create a clone replacing only props that were converted
	else return Object.assign({}, props, propsConverted);
      };
    };
  };
};
