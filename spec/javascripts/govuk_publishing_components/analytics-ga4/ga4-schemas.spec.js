/* eslint-env jasmine */

describe('Google Analytics schemas', function () {
  var schemas

  beforeAll(function () {
    window.GOVUK.analyticsGa4 = window.GOVUK.analyticsGa4 || {}
    window.GOVUK.analyticsGa4.vars = window.GOVUK.analyticsGa4.vars || {}
    window.GOVUK.analyticsGa4.vars.gem_version = 'aVersion'
  })

  beforeEach(function () {
    schemas = new window.GOVUK.analyticsGa4.Schemas()
  })

  it('only allows data from the schema', function () {
    var data = {
      event_name: 'test_event_name',
      type: 'test_type',
      not_valid: 'test_not_valid'
    }
    var expected = {
      event: 'example',
      event_data: {
        event_name: 'test_event_name',
        type: 'test_type',
        url: undefined,
        text: undefined,
        index: {
          index_link: this.undefined,
          index_section: this.undefined,
          index_section_count: this.undefined
        },
        index_total: undefined,
        section: undefined,
        action: undefined,
        external: undefined,
        method: undefined,
        link_domain: undefined,
        link_path_parts: undefined,
        tool_name: undefined,
        percent_scrolled: undefined
      }
    }
    var returned = schemas.mergeProperties(data, 'example')
    expect(returned).toEqual(expected)
  })

  it('handles nested input correctly', function () {
    var data = {
      event_name: 'test_event_name',
      index: {
        index_section: '1'
      }
    }
    var expected = {
      event: 'example',
      event_data: {
        event_name: 'test_event_name',
        type: undefined,
        url: undefined,
        text: undefined,
        index: {
          index_link: this.undefined,
          index_section: '1',
          index_section_count: this.undefined
        },
        index_total: undefined,
        section: undefined,
        action: undefined,
        external: undefined,
        method: undefined,
        link_domain: undefined,
        link_path_parts: undefined,
        tool_name: undefined,
        percent_scrolled: undefined
      }
    }
    var returned = schemas.mergeProperties(data, 'example')
    expect(returned).toEqual(expected)
  })

  it('handles unnested input correctly', function () {
    var data = {
      event_name: 'test_event_name',
      index_section: '1',
      index_link: '3'
    }
    var expected = {
      event: 'example',
      event_data: {
        event_name: 'test_event_name',
        type: undefined,
        url: undefined,
        text: undefined,
        index: {
          index_link: '3',
          index_section: '1',
          index_section_count: this.undefined
        },
        index_total: undefined,
        section: undefined,
        action: undefined,
        external: undefined,
        method: undefined,
        link_domain: undefined,
        link_path_parts: undefined,
        tool_name: undefined,
        percent_scrolled: undefined
      }
    }
    var returned = schemas.mergeProperties(data, 'example')
    expect(returned).toEqual(expected)
  })

  describe('finding and replacing values in an object', function () {
    it('correctly identifies an object', function () {
      expect(schemas.isAnObject({})).toEqual(true)

      expect(schemas.isAnObject('')).not.toEqual(true)
      expect(schemas.isAnObject([])).not.toEqual(true)
      expect(schemas.isAnObject(2)).not.toEqual(true)
      expect(schemas.isAnObject(null)).not.toEqual(true)
      expect(schemas.isAnObject(undefined)).not.toEqual(true)
    })

    it('handles unnested objects', function () {
      var obj = {
        key1: 'value1',
        key2: 'value2'
      }
      var expected = {
        key1: 'value1',
        key2: 'moose'
      }
      expect(schemas.addToObject(obj, 'key2', 'moose')).toEqual(expected)
    })

    it('handles nested objects', function () {
      var obj = {
        key1: 'value1',
        key2: 'value2',
        key3: {
          key4: 'value4',
          key5: 'value5'
        }
      }
      var expected = {
        key1: 'value1',
        key2: 'value2',
        key3: {
          key4: 'value4',
          key5: 'moose'
        }
      }
      expect(schemas.addToObject(obj, 'key5', 'moose')).toEqual(expected)
    })
  })
})
