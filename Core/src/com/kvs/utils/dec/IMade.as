/**
 * IHash
 * 
 * An interface for each hash function to implement
 */
package com.kvs.utils.dec
{
	import flash.utils.ByteArray;

	/**
	 * IHash
	 */	
	public interface IMade
	{
		function getInputSize():uint;
		function getSize():uint;
		function fuck(src:ByteArray):ByteArray;
		function toString():String;
	}
}