import Sortable from 'sortablejs'

export const SortableHook = {
  mounted () {
    const onSort = sortedIds => {
      this.pushEvent('sort', { ids: sortedIds })
    }
    init(this.el, onSort)
  }
}

const init = (element, callback) => {
  const handleClass = element.dataset.sortableHandleClass
  let opts = {
    animation: 150,
    onSort: _evt => {
      callback(
        [...element.querySelectorAll('[data-sortable-id]')].map(
          el => el.dataset.sortableId
        )
      )
    }
  }

  if (handleClass) {
    opts.handle = '.' + handleClass
  }

  new Sortable(element, opts)
}
