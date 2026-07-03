import { LightningElement, api } from "lwc";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";

export default class PortalV2StarRating extends LightningElement {
  @api
  rating;
  @api
  maxStars;
  @api
  ratingOutOf;
  @api
  hasRating = false;
  @api
  canSelect = false;
  @api
  recordId;

  overrideRating;

  starObjects = [];

  ratingStarBlue = SITE_ASSETS + "/img/icons/rating-star-blue.svg";
  ratingStarGrey = SITE_ASSETS + "/img/icons/rating-star-grey.svg";

  connectedCallback() {
    this.initStars();
  }

  initStars() {
    this.starObjects = [];
    for (let i = 0; i < this.maxStars; i++) {
      this.starObjects.push({
        key: i,
        active: i + 1 <= this.calculatedRating,
        src:
          i + 1 <= this.calculatedRating
            ? this.ratingStarBlue
            : this.ratingStarGrey
      });
    }
  }

  get ratingOutOfExists() {
    return this.ratingOutOf;
  }
  get calculatedRating() {
    return this.overrideRating !== undefined
      ? this.overrideRating
      : this.rating;
  }

  handleStarClick(event) {
    if (!this.canSelect) {
      return;
    }
    const { index } = event.target.dataset;
    this.overrideRating = parseInt(index, 10) + 1;
    console.log(`Rating is: ${this.overrideRating}`);
    this.initStars();

    //fire event to let the parent know that the rating has changed
    this.dispatchEvent(
      new CustomEvent("ratingchange", {
        detail: {
          id: this.recordId,
          rating: this.calculatedRating
        }
      })
    );
  }

  @api
  reset() {
    this.overrideRating = this.rating;
    this.initStars();
  }
}