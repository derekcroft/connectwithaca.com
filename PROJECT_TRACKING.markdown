Markus' Progress and Planning Tracker for ACA Work
==================================================

What I've Changed
-----------------

+   Saving a profile now also saves projects and expertises.

+   From the Edit Profile page there's now a way to attach a photo image.

    Once attached, that image now displays both in the sidebar and, in smaller form, next to the profile name and title.

+   Errors looking up some unused JavaScript files no longer appear.

+   Errors related to "document.thisForm" not existing no longer appear.

+   Home Page: Changed "Membership Directory" item to link to the Member List page. It wasn't a link at all before, though it seems it should have been.

To-Do List
----------
In planned-implementation order

+   View Profile: Fix the display to match the old ASP version more closely.

+   Edit Profile: Clean up my implementation of Expertise editing.

    Either use nested attributes or at least do error checking on ProfileExpertise save.

What's Still Broken
-------------------

+   The new upload button is in the Edit Profile form rather than on a separate page linked from the sidebar. This means you can only
    actually upload one image per profile. As best I can tell from reading the code, the old ASP site allowed uploading multiple images
    and selecting which one would appear on the profile page. I could duplicate that if needed, but where things are now is just the simpler
    solution.

+   When a profile already has a photo, the upload button appears without showing it. There's no indicator right by the button that a photo
    is already present.

+   Profile Page: the "View/Print Biography" and "Upload" sidebar items don't do anything.

+   Profile Page: The "Consultant Web Site" link goes to the member's Edit Profile page, not to an external web site as one would expect.

+   Sample Profiles do not appear under the Sample Profiles sidebar item when it is expanded.

+   The old "recruiting_form.asp" page has not be ported to Rails, so links to it are broken. It is linked from the Recruiting page sidebar.

+   The old "application.asp" page has not be ported to Rails, so links to it are broken. It is linked from the "Join ACA" page and its sidebar.

+   On the Dealer Direct page, the body text flows right over the image. Presumably it should flow around it.

+   On the Dealer Direct sidebar, the Submit Opportunity and Content Library items don't do anything.

+   There appears to be no way to navigate to the New User page.

+   Links to member_find.asp are broken (home page). It may be that these should navigate to members/search, but at the moment there's no action for that view.


