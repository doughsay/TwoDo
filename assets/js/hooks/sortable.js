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
  new Sortable(element, {
    onSort: _evt => {
      callback(
        [...element.querySelectorAll('[data-sortable-id]')].map(
          el => el.dataset.sortableId
        )
      )
    }
  })
}
