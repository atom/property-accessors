PropertyAccessors = require '../src/property-accessors'

describe "PropertyAccessors", ->
  [TestClass, instance] = []

  beforeEach ->
    class TestClass
      PropertyAccessors.includeInto(this)

  describe ".advisedAccessor", ->
    it "can run advice before setting/getting a property on a per-instance basis", ->
      TestClass::advisedAccessor 'foo',
        set: setAdvice = jasmine.createSpy("setAdvice")
        get: getAdvice = jasmine.createSpy("getAdvice")

      instance1 = new TestClass
      instance2 = new TestClass

      instance1.foo = 3
      expect(setAdvice).toHaveBeenCalledWith(3, undefined)

      setAdvice.reset()
      instance2.foo = 5
      expect(setAdvice).toHaveBeenCalledWith(5, undefined)

      expect(instance1.foo).toBe 3
      expect(instance2.foo).toBe 5
      expect(getAdvice.callCount).toBe 2

      setAdvice.reset()
      instance1.foo = 6
      expect(setAdvice).toHaveBeenCalledWith(6, 3)

  describe ".lazyAccessor", ->
    it "computes its value lazily on a per-instance basis", ->
      id = 1
      TestClass::lazyAccessor 'foo', -> {id: id++, instance: this}

      instance1 = new TestClass
      instance2 = new TestClass

      expect(instance1.foo).toEqual {id: 1, instance: instance1}
      expect(instance1.foo).toEqual {id: 1, instance: instance1}
      expect(instance2.foo).toEqual {id: 2, instance: instance2}
      expect(instance2.foo).toEqual {id: 2, instance: instance2}

      instance1.foo = 4
      expect(instance1.foo).toBe 4
