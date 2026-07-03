import { LightningElement, api, track } from 'lwc';
export default class LmsSequencer extends LightningElement {
    @api
    get rawItems() { return this._items; }
    set rawItems(val) {
        this._items = val;
        this.buildItems();
    }
    _items = [];
    @track items = [];

    buildItems() {
        this.items = (this._items || []).map((item, i, arr) => ({
            ...item, seq: i + 1, isFirst: i === 0, isLast: i === arr.length - 1,
        }));
    }

    moveUp(e) { this.swap(e.currentTarget.dataset.id, -1); }
    moveDown(e) { this.swap(e.currentTarget.dataset.id, 1); }

    swap(id, dir) {
        const idx = this._items.findIndex(i => i.id === id);
        if (idx + dir < 0 || idx + dir >= this._items.length) return;
        const arr = [...this._items];
        [arr[idx], arr[idx + dir]] = [arr[idx + dir], arr[idx]];
        this._items = arr;
        this.buildItems();
        this.dispatchEvent(new CustomEvent('reorder', { detail: { items: this._items } }));
    }
}
