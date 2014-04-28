/**
 * IPRNG
 * 
 * An interface for classes that can be used a pseudo-random number generators
 * 
 */
package com.kvs.utils.dec
{
	import flash.utils.ByteArray;
		
	public interface IPRNG {
		function getPoolSize():uint;
		function init(key:ByteArray):void;
		function next():uint;
		function dispose():void;
		function toString():String;
	}
}