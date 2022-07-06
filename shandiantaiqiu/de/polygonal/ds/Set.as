package de.polygonal.ds
{
   import flash.utils.Dictionary;
   
   public class Set implements Collection
   {
       
      
      private var _size:int;
      
      private var _set:Dictionary;
      
      public function Set()
      {
         _set = new Dictionary(true);
         super();
         _set = new Dictionary();
      }
      
      public function get size() : int
      {
         return _size;
      }
      
      public function set(obj:*) : void
      {
         if(obj == null)
         {
            return;
         }
         if(obj == undefined)
         {
            return;
         }
         if(_set[obj])
         {
            return;
         }
         _set[obj] = obj;
         ++_size;
      }
      
      public function remove(obj:*) : Boolean
      {
         if(_set[obj] != undefined)
         {
            delete _set[obj];
            --_size;
            return true;
         }
         return false;
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function getIterator() : Iterator
      {
         return new SetIterator(this);
      }
      
      public function toString() : String
      {
         return "[Set, size=" + size + "]";
      }
      
      public function contains(obj:*) : Boolean
      {
         return _set[obj] != undefined;
      }
      
      public function clear() : void
      {
         _set = new Dictionary();
         _size = 0;
      }
      
      public function get(obj:*) : *
      {
         var val:* = _set[obj];
         return val != undefined ? val : null;
      }
      
      public function dump() : String
      {
         var i:* = undefined;
         var s:String = "Set:\n";
         for each(i in _set)
         {
            s += "[val: " + i + "]\n";
         }
         return s;
      }
      
      public function toArray() : Array
      {
         var j:int = 0;
         var i:* = undefined;
         var a:Array = new Array(_size);
         for(i in _set)
         {
            var _loc6_:* = j++;
            a[_loc6_] = i;
         }
         return a;
      }
   }
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Set;

class SetIterator implements Iterator
{
    
   
   private var _size:int;
   
   private var _a:Array;
   
   private var _s:Set;
   
   private var _cursor:int;
   
   function SetIterator(s:Set)
   {
      super();
      _s = s;
      _a = s.toArray();
      _cursor = 0;
      _size = s.size;
   }
   
   public function start() : void
   {
      _cursor = 0;
   }
   
   public function next() : *
   {
      return _a[_cursor++];
   }
   
   public function hasNext() : Boolean
   {
      return _cursor < _size;
   }
   
   public function get data() : *
   {
      return _a[_cursor];
   }
   
   public function set data(obj:*) : void
   {
      _s.remove(_a[_cursor]);
      _s.set(obj);
   }
}
